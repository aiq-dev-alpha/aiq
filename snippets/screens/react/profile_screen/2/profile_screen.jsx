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
    <div className="modern_profile">
      <div className="modern_profile_container">
        <div className="profile_header_modern">
          <button className="back_btn_profile">←</button>
          <button className="menu_btn_profile">⋯</button>
        </div>

        <div className="profile_hero">
          <div className="cover_gradient"></div>
          <div className="avatar_modern">
            <div className="avatar_circle">SJ</div>
            <button className="avatar_edit_btn">📷</button>
          </div>
        </div>

        <div className="profile_info_modern">
          <h1 className="profile_name_modern">{profile.name}</h1>
          <p className="profile_username_modern">{profile.username}</p>
          <p className="profile_bio_modern">{profile.bio}</p>

          <div className="profile_meta_modern">
            <span className="meta_item">📍 {profile.location}</span>
            <span className="meta_item">✉️ {profile.email}</span>
          </div>

          <div className="action_buttons_modern">
            <button className="btn_primary_modern">
              Edit Profile
            </button>
            <button className="btn_secondary_modern">
              Share Profile
            </button>
          </div>
        </div>

        <div className="stats_grid_modern">
          {stats.map((stat, index) => (
            <div key={index} className="stat_card_modern">
              <div className="stat_icon_modern">{stat.icon}</div>
              <div className="stat_value_modern">{stat.value}</div>
              <div className="stat_label_modern">{stat.label}</div>
            </div>
          ))}
        </div>

        <div className="achievements_section_modern">
          <h2 className="section_title_modern">Achievements</h2>
          <div className="achievements_grid">
            {achievements.map((achievement, index) => (
              <div key={index} className="achievement_badge">
                <div className="achievement_icon">{achievement.icon}</div>
                <span>{achievement.title}</span>
              </div>
            ))}
          </div>
        </div>

        <div className="profile_menu_modern">
          <button className="menu_item_modern">
            <span>⚙️ Settings</span>
            <span>→</span>
          </button>
          <button className="menu_item_modern">
            <span>🔔 Notifications</span>
            <span>→</span>
          </button>
          <button className="menu_item_modern">
            <span>🔒 Privacy</span>
            <span>→</span>
          </button>
          <button className="menu_item_modern">
            <span>💳 Billing</span>
            <span>→</span>
          </button>
          <button className="menu_item_modern logout">
            <span>🚪 Sign Out</span>
          </button>
        </div>
      </div>
    </div>
  );
};

export default ProfileScreen;
