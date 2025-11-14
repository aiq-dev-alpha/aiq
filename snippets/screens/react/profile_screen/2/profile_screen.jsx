import React, { useState } from 'react';
import './profile_screen.css';

// Version 2: Modern profile with stats cards and achievements

const ProfileScreen = () => {
  const [isEditing, setIsEditing] = useState(false);
  const [profile, setProfile] = useState({
    name: 'Sarah Johnson',
    username: '@sarahjohnson',
    email: 'sarah.j@example.com',
    bio: 'Product designer & creative thinker. Coffee enthusiast.',
    location: 'San Francisco, CA',
  });

  const stats = [
    { label: 'Posts', value: '127', icon: '📝' },
    { label: 'Followers', value: '2.4K', icon: '👥' },
    { label: 'Following', value: '892', icon: '➕' },
    { label: 'Likes', value: '8.1K', icon: '❤️' },
  ];

  const achievements = [
    { title: 'Early Adopter', icon: '🚀' },
    { title: 'Top Contributor', icon: '⭐' },
    { title: 'Verified', icon: '✓' },
  ];

  return (
    <div className="modern-profile">
      <div className="modern-profile-container">
        <div className="profile-header-modern">
          <button className="back-btn-profile">←</button>
          <button className="menu-btn-profile">⋯</button>
        </div>

        <div className="profile-hero">
          <div className="cover-gradient"></div>
          <div className="avatar-modern">
            <div className="avatar-circle">SJ</div>
            <button className="avatar-edit-btn">📷</button>
          </div>
        </div>

        <div className="profile-info-modern">
          <h1 className="profile-name-modern">{profile.name}</h1>
          <p className="profile-username-modern">{profile.username}</p>
          <p className="profile-bio-modern">{profile.bio}</p>

          <div className="profile-meta-modern">
            <span className="meta-item">📍 {profile.location}</span>
            <span className="meta-item">✉️ {profile.email}</span>
          </div>

          <div className="action-buttons-modern">
            <button className="btn-primary-modern">
              Edit Profile
            </button>
            <button className="btn-secondary-modern">
              Share Profile
            </button>
          </div>
        </div>

        <div className="stats-grid-modern">
          {stats.map((stat, index) => (
            <div key={index} className="stat-card-modern">
              <div className="stat-icon-modern">{stat.icon}</div>
              <div className="stat-value-modern">{stat.value}</div>
              <div className="stat-label-modern">{stat.label}</div>
            </div>
          ))}
        </div>

        <div className="achievements-section-modern">
          <h2 className="section-title-modern">Achievements</h2>
          <div className="achievements-grid">
            {achievements.map((achievement, index) => (
              <div key={index} className="achievement-badge">
                <div className="achievement-icon">{achievement.icon}</div>
                <span>{achievement.title}</span>
              </div>
            ))}
          </div>
        </div>

        <div className="profile-menu-modern">
          <button className="menu-item-modern">
            <span>⚙️ Settings</span>
            <span>→</span>
          </button>
          <button className="menu-item-modern">
            <span>🔔 Notifications</span>
            <span>→</span>
          </button>
          <button className="menu-item-modern">
            <span>🔒 Privacy</span>
            <span>→</span>
          </button>
          <button className="menu-item-modern">
            <span>💳 Billing</span>
            <span>→</span>
          </button>
          <button className="menu-item-modern logout">
            <span>🚪 Sign Out</span>
          </button>
        </div>
      </div>
    </div>
  );
};

export default ProfileScreen;
