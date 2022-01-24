import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kmrs/login/login.dart';
import 'package:kmrs/sign_up/sign_up.dart';
import 'package:kmrs/theme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:formz/formz.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'เข้าสู่ระบบไม่สำเร็จ'),
              ),
            );
        }
      },
      child: Align(
        alignment: const Alignment(0, -1 / 3),
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: const [
                BackgroundLogIn(),
                LoginCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
          key: const Key('loginForm_emailInput_textField'),
          onChanged: (email) => context.read<LoginCubit>().emailChanged(email),
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.person_outlined),
            labelText: 'ชื่อผู้ใช้',
            helperText: '',
            errorText: state.email.invalid
                ? 'กรุณาระบุบชื่อผู้ใช้ ตัวอย่าง kukm@kurms'
                : null,
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          key: const Key('loginForm_passwordInput_textField'),
          onChanged: (password) =>
              context.read<LoginCubit>().passwordChanged(password),
          obscureText: true,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.lock_outline),
            labelText: 'รหัสผ่าน',
            helperText: '',
            errorText: state.password.invalid ? 'กรุณากรอกรหัสผ่าน' : null,
          ),
        );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : ElevatedButton(
                key: const Key('loginForm_continue_raisedButton'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(150, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  primary: theme.primaryColor,
                ),
                onPressed: state.status.isValidated
                    ? () => context.read<LoginCubit>().logInWithCredentials()
                    : null,
                child: const Text('เข้าสู่ระบบ'),
              );
      },
    );
  }
}

class _GoogleLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ElevatedButton.icon(
      key: const Key('loginForm_googleLogin_raisedButton'),
      label: const Text(
        'SIGN IN WITH GOOGLE',
        style: TextStyle(color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        primary: theme.colorScheme.secondary,
      ),
      icon: const Icon(FontAwesomeIcons.google, color: Colors.white),
      onPressed: () => context.read<LoginCubit>().logInWithGoogle(),
    );
  }
}

class _SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextButton(
      key: const Key('loginForm_createAccount_flatButton'),
      onPressed: () => Navigator.of(context).push<void>(SignUpPage.route()),
      child: Text(
        'CREATE ACCOUNT',
        style: TextStyle(color: theme.primaryColor),
      ),
    );
  }
}

class BackgroundLogIn extends StatelessWidget {
  const BackgroundLogIn({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: SizedBox(
        height: double.infinity,
        width: MediaQuery.of(context).size.width * 0.6,
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: const [
              Text(
                "ระบบรายงานการจัดการความรู้ภายในส่วนงาน",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "ส่วนงานการจัดการความรู้ภายใน",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "มหาวิทยาลัยเกษตรศาสตร",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginCard extends StatelessWidget {
  const LoginCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 425,
              child: Card(
                margin: const EdgeInsets.all(40),
                elevation: 4,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(25),
                  ),
                ),
                child: Center(
                  child: Container(
                    margin: const EdgeInsets.all(40),
                    child: Column(
                      children: [
                        const Text(
                          "ลงชื่อเข้าใช้งาน",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: 100,
                          child: Divider(
                            color: theme.primaryColor,
                            thickness: 2,
                          ),
                        ),
                        const SizedBox(height: 32),
                        _EmailInput(),
                        const SizedBox(height: 12),
                        _PasswordInput(),
                        const SizedBox(height: 22),
                        _LoginButton(),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
