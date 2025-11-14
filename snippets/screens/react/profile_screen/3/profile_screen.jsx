import React from 'react';
import './profile_screen.css';

// Version 3: Minimal clean profile

const ProfileScreen = () => {
  const profile = {
    name: 'Alex Morgan',
    email: 'alex.morgan@example.com',
    joined: 'March 2024',
  };

  const menuSections = [
    {
      title: 'Account',
      items: [
        { label: 'Personal information', href: '#' },
        { label: 'Security', href: '#' },
        { label: 'Notifications', href: '#' },
      ],
    },
    {
      title: 'Preferences',
      items: [
        { label: 'Appearance', href: '#' },
        { label: 'Language', href: '#' },
        { label: 'Privacy', href: '#' },
      ],
    },
  ];

  return (
    <div className="minimal-profile">
      <div className="minimal-profile-content">
        <header className="minimal-profile-header">
          <div className="profile-avatar-minimal">AM</div>
          <div className="profile-details-minimal">
            <h1 className="profile-name-minimal">{profile.name}</h1>
            <p className="profile-email-minimal">{profile.email}</p>
            <p className="profile-joined-minimal">Joined {profile.joined}</p>
          </div>
        </header>

        {menuSections.map((section, index) => (
          <div key={index} className="profile-section-minimal">
            <h2 className="section-heading-minimal">{section.title}</h2>
            <div className="section-items-minimal">
              {section.items.map((item, itemIndex) => (
                <a
                  key={itemIndex}
                  href={item.href}
                  className="profile-link-minimal"
                >
                  {item.label}
                  <span className="arrow-minimal">→</span>
                </a>
              ))}
            </div>
          </div>
        ))}

        <div className="profile-section-minimal">
          <h2 className="section-heading-minimal">Actions</h2>
          <div className="section-items-minimal">
            <button className="profile-link-minimal">
              Edit profile
            </button>
            <button className="profile-link-minimal danger">
              Sign out
            </button>
          </div>
        </div>
      </div>
    </div>
  );
};

export default ProfileScreen;
