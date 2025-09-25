import React from 'react';
import { motion } from 'framer-motion';
import { useInView } from 'react-intersection-observer';

const Experience: React.FC = () => {
  const [ref, inView] = useInView({
    triggerOnce: true,
    threshold: 0.1,
  });

  const experiences = [
    {
      title: 'Senior Full Stack Developer',
      company: 'Tech Solutions Inc.',
      period: '2022 - Present',
      description: [
        'Led development of microservices architecture serving 1M+ users',
        'Improved application performance by 40% through optimization',
        'Mentored junior developers and conducted code reviews',
        'Implemented CI/CD pipelines reducing deployment time by 60%'
      ]
    },
    {
      title: 'Full Stack Developer',
      company: 'Digital Agency Co.',
      period: '2020 - 2022',
      description: [
        'Developed 15+ web applications for various clients',
        'Collaborated with designers to implement responsive UIs',
        'Integrated third-party APIs and payment gateways',
        'Maintained and optimized existing applications'
      ]
    },
    {
      title: 'Frontend Developer',
      company: 'StartUp Ventures',
      period: '2019 - 2020',
      description: [
        'Built responsive web applications using React and TypeScript',
        'Implemented state management with Redux and Context API',
        'Worked closely with backend team for API integration',
        'Participated in agile development processes'
      ]
    },
    {
      title: 'Junior Developer',
      company: 'Web Solutions Ltd.',
      period: '2018 - 2019',
      description: [
        'Assisted in developing web applications using HTML, CSS, JavaScript',
        'Fixed bugs and implemented feature enhancements',
        'Learned best practices and coding standards',
        'Contributed to documentation and testing'
      ]
    }
  ];

  return (
    <section id="experience" className="section-padding bg-gray-50 dark:bg-gray-800">
      <div className="max-w-7xl mx-auto">
        <motion.div
          ref={ref}
          initial={{ opacity: 0, y: 20 }}
          animate={inView ? { opacity: 1, y: 0 } : {}}
          transition={{ duration: 0.6 }}
        >
          <h2 className="text-4xl font-bold text-center mb-12">
            Work <span className="gradient-text">Experience</span>
          </h2>

          <div className="space-y-8">
            {experiences.map((exp, index) => (
              <motion.div
                key={index}
                initial={{ opacity: 0, x: index % 2 === 0 ? -20 : 20 }}
                animate={inView ? { opacity: 1, x: 0 } : {}}
                transition={{ duration: 0.6, delay: index * 0.1 }}
                className="bg-white dark:bg-gray-900 rounded-lg p-6 shadow-lg"
              >
                <div className="flex flex-col md:flex-row md:justify-between md:items-start mb-4">
                  <div>
                    <h3 className="text-xl font-semibold">{exp.title}</h3>
                    <p className="text-blue-600 dark:text-blue-400">{exp.company}</p>
                  </div>
                  <span className="text-gray-600 dark:text-gray-400 mt-2 md:mt-0">{exp.period}</span>
                </div>
                <ul className="list-disc list-inside space-y-2 text-gray-600 dark:text-gray-400">
                  {exp.description.map((item, i) => (
                    <li key={i}>{item}</li>
                  ))}
                </ul>
              </motion.div>
            ))}
          </div>
        </motion.div>
      </div>
    </section>
  );
};

export default Experience;