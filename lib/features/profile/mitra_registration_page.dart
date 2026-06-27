import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:http/http.dart' as http;
import '../../core/pocketbase/pb.dart';

class MitraRegistrationPage extends StatefulWidget {
  const MitraRegistrationPage({super.key});

  @override
  State<MitraRegistrationPage> createState() => _MitraRegistrationPageState();
}

class _MitraRegistrationPageState extends State<MitraRegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _bankAccountController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  XFile? _ktpPhoto;
  XFile? _selfiePhoto;
  
  bool _isLoading = false;
  bool _obscurePassword = true;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(bool isKtp) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        if (isKtp) {
          _ktpPhoto = image;
        } else {
          _selfiePhoto = image;
        }
      });
    }
  }

  Future<void> _submitForm() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    
    if (_ktpPhoto == null || _selfiePhoto == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Foto KTP dan Selfie wajib diunggah!')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final user = pb.authStore.model as RecordModel?;
    if (user == null) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      late http.MultipartFile ktpMultipart;
      late http.MultipartFile selfieMultipart;

      if (kIsWeb) {
        final ktpBytes = await _ktpPhoto!.readAsBytes();
        ktpMultipart = http.MultipartFile.fromBytes('ktp_photo', ktpBytes, filename: _ktpPhoto!.name);
        
        final selfieBytes = await _selfiePhoto!.readAsBytes();
        selfieMultipart = http.MultipartFile.fromBytes('selfie_photo', selfieBytes, filename: _selfiePhoto!.name);
      } else {
        ktpMultipart = await http.MultipartFile.fromPath('ktp_photo', _ktpPhoto!.path);
        selfieMultipart = await http.MultipartFile.fromPath('selfie_photo', _selfiePhoto!.path);
      }

      await pb.collection('partners').create(
        body: {
          'bio': _bioController.text,
          'bank_name': _bankNameController.text,
          'bank_account': _bankAccountController.text,
          'is_verified': false,
          'is_active': true,
          'email': user.getStringValue('email'),
          'phone': user.getStringValue('phone'),
          'password': _passwordController.text,
          'passwordConfirm': _passwordController.text,
        },
        files: [
          ktpMultipart,
          selfieMultipart,
        ],
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pendaftaran berhasil dikirim! Menunggu persetujuan Admin.')),
      );
      Navigator.pop(context, true); // Return true to indicate success
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _bioController.dispose();
    _bankNameController.dispose();
    _bankAccountController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pendaftaran Mitra'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Lengkapi Data Anda',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Silakan unggah dokumen yang diperlukan untuk diverifikasi oleh admin.',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              
              _buildImagePickerField(
                label: 'Foto KTP',
                imageFile: _ktpPhoto,
                onTap: () => _pickImage(true),
              ),
              const SizedBox(height: 16),
              
              _buildImagePickerField(
                label: 'Foto Selfie (Wajah)',
                imageFile: _selfiePhoto,
                onTap: () => _pickImage(false),
              ),
              const SizedBox(height: 24),

              TextFormField(
                controller: _bioController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Biografi / Deskripsi Singkat',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _bankNameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Bank (misal: BCA, Mandiri)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _bankAccountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Nomor Rekening',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 16),

              const Text(
                'Karena Mitra merupakan akun terpisah, silakan buat kata sandi untuk akun mitra Anda.',
                style: TextStyle(color: Colors.blue, fontSize: 12),
              ),
              const SizedBox(height: 8),

              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Kata Sandi Akun Mitra',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                validator: (value) => (value == null || value.length < 8) ? 'Kata sandi minimal 8 karakter' : null,
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0050CB),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Kirim Pendaftaran',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePickerField({
    required String label,
    required XFile? imageFile,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey.shade100,
            ),
            child: imageFile != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: kIsWeb 
                        ? Image.network(imageFile.path, fit: BoxFit.cover)
                        : Image.file(File(imageFile.path), fit: BoxFit.cover),
                  )
                : const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.camera_alt, size: 40, color: Colors.grey),
                      SizedBox(height: 8),
                      Text('Ketuk untuk mengunggah'),
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}
