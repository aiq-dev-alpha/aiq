import 'package:flutter/material.dart';

class CustomSection extends StatefulWidget {
  final List<Testimonial> testimonials;
  final String? title;
  final Color? backgroundColor;

  const CustomSection({
    Key? key,
    required this.testimonials,
    this.title,
    this.backgroundColor,
  }) : super(key: key);

  @override
  State<CustomSection> createState() => _CustomSectionState();
}

class Testimonial {
  final String name;
  final String? role;
  final String? company;
  final String text;
  final String? avatarUrl;
  final int rating;

  const Testimonial({
    required this.name,
    this.role,
    this.company,
    required this.text,
    this.avatarUrl,
    this.rating = 5,
  });
}

class _CustomSectionState extends State<CustomSection> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 64),
      color: widget.backgroundColor ?? Colors.grey.shade100,
      child: Column(
        children: [
          if (widget.title != null) ...[
            Text(
              widget.title!,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
          ],
          SizedBox(
            height: 300,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
              },
              itemCount: widget.testimonials.length,
              itemBuilder: (context, index) {
                final testimonial = widget.testimonials[index];
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (starIndex) {
                          return Icon(
                            starIndex < testimonial.rating
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.amber,
                            size: 24,
                          );
                        }),
                      ),
                      const SizedBox(height: 24),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Text(
                            '"${testimonial.text}"',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade800,
                              fontStyle: FontStyle.italic,
                              height: 1.6,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: Colors.grey.shade300,
                            backgroundImage: testimonial.avatarUrl != null
                                ? NetworkImage(testimonial.avatarUrl!)
                                : null,
                            child: testimonial.avatarUrl == null
                                ? const Icon(Icons.person, color: Colors.white)
                                : null,
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                testimonial.name,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (testimonial.role != null)
                                Text(
                                  '${testimonial.role}${testimonial.company != null ? ' at ${testimonial.company}' : ''}',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.testimonials.length, (index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentPage == index ? 32 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _currentPage == index
                      ? Theme.of(context).primaryColor
                      : Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
