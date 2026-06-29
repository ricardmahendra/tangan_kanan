import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../../../core/pocketbase/pb.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailOrPhoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;
  
  get Navigator => null;

  @override
  void dispose() {
    _emailOrPhoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submitLogin() async {
  if (!(_formKey.currentState?.validate() ?? false)) {
    return;
  }

  setState(() {
    _isLoading = true;
  });

  final identity = _emailOrPhoneController.text.trim();
  final password = _passwordController.text;

  String loginEmail = identity;

  try {
    // Jika input bukan email
    if (!identity.contains('@')) {
      // Validasi nomor HP
      if (!RegExp(r'^[0-9]+$').hasMatch(identity)) {
        throw Exception(
          'Nomor HP tidak valid.',
        );
      }

      final record = await pb.collection('users').getFirstListItem(
        pb.filter(
          'phone = {:phone}',
          {'phone': identity},
        ),
      );

      loginEmail =
          (record.data['email'] as String?)
                  ?.trim() ??
              '';

      if (loginEmail.isEmpty) {
        throw Exception(
          'Akun tidak ditemukan untuk nomor HP ini.',
        );
      }
    }

    final authData = await pb
        .collection('users')
        .authWithPassword(
          loginEmail,
          password,
        );

    final user = authData.record;

    final bool isActive =
        user.getBoolValue('is_active');

    if (!isActive) {
      pb.authStore.clear();

      throw Exception(
        'Akun Anda dinonaktifkan oleh admin.',
      );
    }

    final role =
        user.getStringValue('role');

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Selamat datang ${user.getStringValue('name')}',
        ),
      ),
    );

    if (role == 'admin') {
      context.go('/admin');
    } else if (role == 'mitra') {
      context.go('/mitra');
    } else {
      context.go('/main');
    }

  } catch (error) {
    final message = error is Exception
        ? error
            .toString()
            .replaceFirst('Exception: ', '')
        : 'Login gagal. Periksa email atau kata sandi Anda.';

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 20,
            ),
            child: Column(
              children: [
                // LOGO
                Image.network(
                  'https://storage.googleapis.com/tagjs-prod.appspot.com/v1/UN2VKAlfyY/mwvn2a6s_expires_30_days.png',
                  width: 70,
                  height: 70,
                ),

                const SizedBox(height: 12),

                // TITLE
                RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: 'Selamat Datang di\n',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text: 'TanganKanan',
                        style: TextStyle(
                          color: Color(0xFF0050CB),
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  'Solusi cerdas untuk segala kebutuhan rumah\n'
                  'tangga Anda.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 24),

                // CARD LOGIN
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFE6E8EE),
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.05),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _emailOrPhoneController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText:
                                'Nomor HP atau Email',
                            prefixIcon: const Icon(
                              Icons.person_outline,
                              size: 20,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding:
                                const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 14,
                            ),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(8),
                            ),
                          ),
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty) {
                              return 'Masukkan email atau nomor HP';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 12),

                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            hintText: 'Kata Sandi',
                            prefixIcon: const Icon(
                              Icons.lock_outline,
                              size: 20,
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
                            fillColor: Colors.white,
                            contentPadding:
                                const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 14,
                            ),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(8),
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

                        const SizedBox(height: 18),

                        SizedBox(
                            width: double.infinity,
                            height: 46,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _submitLogin,
                              style:
                                  ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color(0xFF0050CB),
                                elevation: 0,
                                shape:
                                    RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(8),
                                ),
                              ),
                              child: _isLoading
                                ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  'Masuk',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),

                        const SizedBox(height: 14),

                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color:
                                    Colors.grey.shade300,
                              ),
                            ),
                            const Padding(
                              padding:
                                  EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              child: Text(
                                'atau',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color:
                                    Colors.grey.shade300,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        SizedBox(
                          width: double.infinity,
                          height: 46,
                          child: OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.g_mobiledata,
                              color: Colors.red,
                              size: 26,
                            ),
                            label: const Text(
                              'Masuk dengan Google',
                              style: TextStyle(
                                color: Colors.black87,
                              ),
                            ),
                            style:
                                OutlinedButton.styleFrom(
                              shape:
                                  RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                  8,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Belum punya akun? ',
                              style: TextStyle(
                                fontSize: 13,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  '/register',
                                );
                              },
                              child: const Text(
                                'Daftar',
                                style: TextStyle(
                                  color:
                                      Color(0xFF0050CB),
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Syarat & Ketentuan',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),

                const SizedBox(height: 4),

                const Text(
                  '© 2024 TanganKanan. Hak Cipta Dilindungi.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}