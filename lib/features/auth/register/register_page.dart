import 'package:flutter/material.dart';
import '../../../core/pocketbase/pb.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _agreeTerms = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submitRegister() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final password = _passwordController.text;

    try {
      await pb.collection('users').create(
        body: {
          'name': name,
          'email': email,
          'phone': phone,
          'password': password,
          'passwordConfirm': password,
        },
      );

      await pb.collection('users').authWithPassword(
        email,
        password,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Akun $name berhasil dibuat'),
        ),
      );

      Navigator.pushReplacementNamed(context, '/home');
    } catch (error) {
      final message = error is Exception
          ? error.toString().replaceFirst('Exception: ', '')
          : 'Pendaftaran gagal. Periksa kembali data Anda.';

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // LOGO
                Row(
                  children: [
                    Image.network(
                      'https://storage.googleapis.com/tagjs-prod.appspot.com/v1/UN2VKAlfyY/mwvn2a6s_expires_30_days.png',
                      width: 28,
                      height: 28,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'TanganKanan',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                const Text(
                  'Buat Akun Baru',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0B1C30),
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Mulai perjalanan Anda menuju rumah\nyang lebih baik hari ini.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 24),

                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: const Color(0xFFE5E7EB),
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(
                          0,
                          0,
                          0,
                          0.04,
                        ),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildTextField(
                        controller: _nameController,
                        labelText: 'Nama Lengkap',
                        hintText: 'Contoh: Budi Santoso',
                        icon: Icons.person_outline,
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty) {
                            return 'Masukkan nama lengkap';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 14),

                      _buildTextField(
                        controller: _emailController,
                        labelText: 'Email',
                        hintText: 'nama@gmail.com',
                        icon: Icons.email_outlined,
                        keyboardType:
                            TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty) {
                            return 'Masukkan email';
                          }

                          if (!RegExp(
                            r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                          ).hasMatch(value.trim())) {
                            return 'Masukkan email yang valid';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 14),

                      _buildTextField(
                        controller: _phoneController,
                        labelText: 'Nomor HP',
                        hintText: '0812xxxxxxx',
                        icon: Icons.phone_android_outlined,
                        keyboardType:
                            TextInputType.phone,
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty) {
                            return 'Masukkan nomor HP';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 14),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Kata Sandi',
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      const SizedBox(height: 6),

                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          hintText: 'Min. 8 karakter',
                          prefixIcon: const Icon(
                            Icons.lock_outline,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword =
                                    !_obscurePassword;
                              });
                            },
                          ),
                          filled: true,
                          fillColor:
                              const Color(0xFFF3F4F6),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(
                              10,
                            ),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder:
                              OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(
                              10,
                            ),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty) {
                            return 'Masukkan kata sandi';
                          }

                          if (value.length < 8) {
                            return 'Kata sandi harus minimal 8 karakter';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 10),

                      Row(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: _agreeTerms,
                            onChanged: (value) {
                              setState(() {
                                _agreeTerms =
                                    value ?? false;
                              });
                            },
                            activeColor:
                                const Color(0xFF0050CB),
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(
                                top: 12,
                              ),
                              child: RichText(
                                text: const TextSpan(
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 11,
                                  ),
                                  children: [
                                    TextSpan(
                                      text:
                                          'Saya setuju dengan ',
                                    ),
                                    TextSpan(
                                      text:
                                          'Syarat & Ketentuan',
                                      style: TextStyle(
                                        color: Color(
                                            0xFF0050CB),
                                        fontWeight:
                                            FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text:
                                          ' serta Kebijakan Privasi TanganKanan.',
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _submitRegister,
                          style:
                              ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color(0xFF0050CB),
                            elevation: 0,
                            shape:
                                RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                10,
                              ),
                            ),
                          ),
                          child: const Text(
                            'Daftar',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight:
                                  FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.grey.shade300,
                      ),
                    ),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                      child: Text(
                        'Atau daftar dengan',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.grey.shade300,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.g_mobiledata,
                          color: Colors.red,
                          size: 24,
                        ),
                        label: const Text(
                          'Google',
                          style: TextStyle(
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.facebook,
                          color: Colors.blue,
                        ),
                        label: const Text(
                          'Facebook',
                          style: TextStyle(
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text.rich(
                      TextSpan(
                        text: 'Sudah punya akun? ',
                        style: TextStyle(
                          color: Colors.black87,
                        ),
                        children: [
                          TextSpan(
                            text: 'Masuk',
                            style: TextStyle(
                              color: Color(0xFF0050CB),
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    required IconData icon,
    TextInputType keyboardType =
        TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: TextStyle(
            color: Colors.grey.shade700,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: Icon(icon),
            filled: true,
            fillColor: const Color(0xFFF3F4F6),
            border: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            enabledBorder:
                OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }
}