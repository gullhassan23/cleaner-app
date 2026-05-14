import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';

import '../../../controllers/vault_controller.dart';
import '../../../widgets/vault/vault_numeric_pad.dart';

class VaultSetupPinPage extends StatefulWidget {
  const VaultSetupPinPage({super.key});

  @override
  State<VaultSetupPinPage> createState() => _VaultSetupPinPageState();
}

class _VaultSetupPinPageState extends State<VaultSetupPinPage> {
  int _step = 0;
  String _first = '';
  String _second = '';
  bool _bio = true;
  bool _busy = false;

  VaultController get _c => Get.find<VaultController>();

  String get _buffer => _step == 0 ? _first : _second;

  set _buffer(String v) {
    if (_step == 0) {
      _first = v;
    } else {
      _second = v;
    }
  }

  Future<void> _checkBioDefault() async {
    final la = LocalAuthentication();
    final supported = await la.isDeviceSupported();
    final can = await la.canCheckBiometrics;
    if (mounted) {
      setState(() => _bio = supported && can);
    }
  }

  @override
  void initState() {
    super.initState();
    _checkBioDefault();
  }

  void _onDigit(String d) {
    if (_buffer.length >= 4) return;
    setState(() => _buffer += d);
  }

  void _onDelete() {
    if (_buffer.isEmpty) return;
    setState(() => _buffer = _buffer.substring(0, _buffer.length - 1));
  }

  Future<void> _next() async {
    if (_buffer.length != 4) return;
    if (_step == 0) {
      setState(() => _step = 1);
      return;
    }
    if (_first != _second) {
      Get.snackbar('Vault', 'PINs do not match. Start again.');
      setState(() {
        _step = 0;
        _first = '';
        _second = '';
      });
      return;
    }
    setState(() => _busy = true);
    final res = await _c.completeSetup(
      pin: _first,
      enableBiometric: _bio,
    );
    if (!mounted) return;
    setState(() => _busy = false);
    if (!res.isSuccess) {
      Get.snackbar('Vault', res.errorMessage ?? 'Setup failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 12),
            Text(
              _step == 0 ? 'Create a 4-digit PIN' : 'Confirm your PIN',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: cs.onSurface,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _step == 0
                  ? 'You will use this PIN to unlock the vault.'
                  : 'Enter the same PIN again.',
              textAlign: TextAlign.center,
              style: TextStyle(color: cs.onSurfaceVariant, fontSize: 14),
            ),
            const SizedBox(height: 28),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (i) {
                final filled = i < _buffer.length;
                return Container(
                  width: 14,
                  height: 14,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: filled ? cs.primary : cs.outline.withValues(alpha: 0.45),
                  ),
                );
              }),
            ),
            const SizedBox(height: 28),
            if (_step == 1) ...[
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  'Enable Face ID / fingerprint',
                  style: TextStyle(color: cs.onSurface, fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  'Unlock the vault without typing your PIN.',
                  style: TextStyle(color: cs.onSurfaceVariant, fontSize: 12),
                ),
                value: _bio,
                onChanged: (v) => setState(() => _bio = v),
              ),
              const SizedBox(height: 8),
            ],
            const Spacer(),
            VaultNumericPad(
              onDigit: _onDigit,
              onDelete: _onDelete,
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed:
                  _busy || _buffer.length != 4
                      ? null
                      : () {
                        if (_step == 0) {
                          setState(() => _step = 1);
                        } else {
                          unawaited(_next());
                        }
                      },
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child:
                  _busy
                      ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                      : Text(
                        _step == 0 ? 'Continue' : 'Finish setup',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
