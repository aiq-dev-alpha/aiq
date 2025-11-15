import 'package:flutter/material.dart';

class CustomSection extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<TeamMember> members;
  final Color? backgroundColor;

  const CustomSection({
    Key? key,
    required this.title,
    this.subtitle,
    required this.members,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(48),
      color: backgroundColor ?? Colors.white,
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 12),
            Text(
              subtitle!,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: 48),
          Wrap(
            spacing: 32,
            runSpacing: 40,
            alignment: WrapAlignment.center,
            children: members.map((member) {
              return SizedBox(
                width: 240,
                child: Column(
                  children: [
                    Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: member.imageUrl != null
                            ? DecorationImage(
                                image: NetworkImage(member.imageUrl!),
                                fit: BoxFit.cover,
                              )
                            : null,
                        color: member.imageUrl == null
                            ? Colors.grey.shade300
                            : null,
                      ),
                      child: member.imageUrl == null
                          ? const Icon(Icons.person, size: 64, color: Colors.white)
                          : null,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      member.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      member.role,
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (member.bio != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        member.bio!,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class TeamMember {
  final String name;
  final String role;
  final String? bio;
  final String? imageUrl;

  const TeamMember({
    required this.name,
    required this.role,
    this.bio,
    this.imageUrl,
  });
}
