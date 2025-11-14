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
    <div className="minimal_profile">
      <div className="minimal_profile_content">
        <header className="minimal_profile_header">
          <div className="profile_avatar_minimal">AM</div>
          <div className="profile_details_minimal">
            <h1 className="profile_name_minimal">{profile.name}</h1>
            <p className="profile_email_minimal">{profile.email}</p>
            <p className="profile_joined_minimal">Joined {profile.joined}</p>
          </div>
        </header>

        {menuSections.map((section, index) => (
          <div key={index} className="profile_section_minimal">
            <h2 className="section_heading_minimal">{section.title}</h2>
            <div className="section_items_minimal">
              {section.items.map((item, itemIndex) => (
                <a
                  key={itemIndex}
                  href={item.href}
                  className="profile_link_minimal"
                >
                  {item.label}
                  <span className="arrow_minimal">→</span>
                </a>
              ))}
            </div>
          </div>
        ))}

        <div className="profile_section_minimal">
          <h2 className="section_heading_minimal">Actions</h2>
          <div className="section_items_minimal">
            <button className="profile_link_minimal">
              Edit profile
            </button>
            <button className="profile_link_minimal danger">
              Sign out
            </button>
          </div>
        </div>
      </div>
    </div>
  );
};

export default ProfileScreen;
