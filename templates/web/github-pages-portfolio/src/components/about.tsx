import React from 'react';
import { motion } from 'framer-motion';
import { useInView } from 'react-intersection-observer';

const About: React.FC = () => {
  const [ref, inView] = useInView({
    triggerOnce: true,
    threshold: 0.1,
  });

  return (
    <section id="about" className="section-padding bg-white dark:bg-gray-900">
      <div className="max-w-7xl mx-auto">
        <motion.div
          ref={ref}
          initial={{ opacity: 0, y: 20 }}
          animate={inView ? { opacity: 1, y: 0 } : {}}
          transition={{ duration: 0.6 }}
        >
          <h2 className="text-4xl font-bold text-center mb-12">
            About <span className="gradient-text">Me</span>
          </h2>

          <div className="grid md:grid-cols-2 gap-12 items-center">
            <div className="space-y-6">
              <p className="text-gray-600 dark:text-gray-400 text-lg">
                I'm a passionate Full Stack Developer with expertise in building scalable web applications
                and cloud solutions. With a strong foundation in both frontend and backend technologies,
                I enjoy tackling complex problems and creating innovative solutions.
              </p>
              <p className="text-gray-600 dark:text-gray-400 text-lg">
                My journey in software development started with curiosity about how things work on the web,
                and has evolved into a career focused on creating impactful digital experiences.
              </p>
              <p className="text-gray-600 dark:text-gray-400 text-lg">
                When I'm not coding, you can find me exploring new technologies, contributing to open-source
                projects, or sharing knowledge with the developer community.
              </p>
            </div>

            <div className="grid grid-cols-2 gap-4">
              <div className="bg-gradient-to-br from-blue-50 to-purple-50 dark:from-blue-900/20 dark:to-purple-900/20 p-6 rounded-lg">
                <h3 className="text-3xl font-bold gradient-text">5+</h3>
                <p className="text-gray-600 dark:text-gray-400">Years Experience</p>
              </div>
              <div className="bg-gradient-to-br from-green-50 to-teal-50 dark:from-green-900/20 dark:to-teal-900/20 p-6 rounded-lg">
                <h3 className="text-3xl font-bold text-green-600">50+</h3>
                <p className="text-gray-600 dark:text-gray-400">Projects Completed</p>
              </div>
              <div className="bg-gradient-to-br from-orange-50 to-red-50 dark:from-orange-900/20 dark:to-red-900/20 p-6 rounded-lg">
                <h3 className="text-3xl font-bold text-orange-600">20+</h3>
                <p className="text-gray-600 dark:text-gray-400">Happy Clients</p>
              </div>
              <div className="bg-gradient-to-br from-indigo-50 to-blue-50 dark:from-indigo-900/20 dark:to-blue-900/20 p-6 rounded-lg">
                <h3 className="text-3xl font-bold text-indigo-600">15+</h3>
                <p className="text-gray-600 dark:text-gray-400">Technologies</p>
              </div>
            </div>
          </div>
        </motion.div>
      </div>
    </section>
  );
};

export default About;