import 'package:dojo_challenge_app/core/parameter/data_source.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DataSourceCard extends StatelessWidget {
  const DataSourceCard({
    super.key,
    required this.icon,
    required this.label,
    required this.source,
    required this.loggedIn,
  });

  final IconData icon;
  final String label;
  final DataSource source;
  final bool loggedIn;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          if (loggedIn) {
            context.push('/popular-movies', extra: source);
          } else {
            context.push('/sign-in');
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
          child: Row(
            children: [
              Icon(icon, color: Colors.amber, size: 28),
              const SizedBox(width: 16),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
