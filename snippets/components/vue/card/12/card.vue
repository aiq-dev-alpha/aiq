<template>
  <div class="event-card">
    <div class="event-date">
      <div class="month">{{ monthName }}</div>
      <div class="day">{{ dayNumber }}</div>
    </div>
    <div class="event-content">
      <h3 class="event-title">{{ title }}</h3>
      <div class="event-meta">
        <div class="meta-item">
          <span class="icon">🕐</span>
          <span>{{ startTime }} - {{ endTime }}</span>
        </div>
        <div class="meta-item">
          <span class="icon">📍</span>
          <span>{{ location }}</span>
        </div>
        <div v-if="attendees" class="meta-item">
          <span class="icon">👥</span>
          <span>{{ attendees.length }} attending</span>
        </div>
      </div>
      <div class="attendees-preview">
        <div v-for="(attendee, i) in attendees?.slice(0, 3)" :key="i" class="attendee-avatar">
          <img :src="attendee.avatar" :alt="attendee.name" />
        </div>
        <div v-if="attendees && attendees.length > 3" class="more-attendees">
          +{{ attendees.length - 3 }}
        </div>
      </div>
      <button class="rsvp-button" @click="$emit('rsvp')">
        {{ rsvpStatus === 'going' ? 'You're Going ✓' : 'RSVP' }}
      </button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue';

interface Attendee {
  name: string;
  avatar: string;
}

interface Props {
  date: string;
  title: string;
  startTime: string;
  endTime: string;
  location: string;
  attendees?: Attendee[];
  rsvpStatus?: 'going' | 'maybe' | 'not_going';
}

const props = defineProps<Props>();

defineEmits<{
  rsvp: [];
}>();

const eventDate = computed(() => new Date(props.date));
const monthName = computed(() => eventDate.value.toLocaleString('en-US', { month: 'short' }));
const dayNumber = computed(() => eventDate.value.getDate());
</script>

<style scoped>
.event-card {
  display: flex;
  gap: 1.5rem;
  padding: 1.5rem;
  background: white;
  border-radius: 16px;
  border-left: 4px solid #8b5cf6;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
  transition: all 0.3s;
}

.event-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 30px rgba(0, 0, 0, 0.12);
}

.event-date {
  flex-shrink: 0;
  width: 80px;
  text-align: center;
  padding: 1rem;
  background: linear-gradient(135deg, #8b5cf6 0%, #7c3aed 100%);
  color: white;
  border-radius: 12px;
}

.month {
  font-size: 0.875rem;
  font-weight: 600;
  text-transform: uppercase;
  margin-bottom: 0.5rem;
}

.day {
  font-size: 2.5rem;
  font-weight: 700;
  line-height: 1;
}

.event-content {
  flex: 1;
}

.event-title {
  margin: 0 0 1rem 0;
  font-size: 1.5rem;
  font-weight: 700;
  color: #111827;
}

.event-meta {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
  margin-bottom: 1rem;
}

.meta-item {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  color: #6b7280;
  font-size: 0.875rem;
}

.icon {
  font-size: 1rem;
}

.attendees-preview {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  margin-bottom: 1rem;
}

.attendee-avatar {
  width: 32px;
  height: 32px;
  border-radius: 50%;
  border: 2px solid white;
  overflow: hidden;
  margin-left: -8px;
}

.attendee-avatar:first-child {
  margin-left: 0;
}

.attendee-avatar img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.more-attendees {
  width: 32px;
  height: 32px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #e5e7eb;
  border-radius: 50%;
  font-size: 0.75rem;
  font-weight: 700;
  color: #6b7280;
  margin-left: -8px;
}

.rsvp-button {
  padding: 0.75rem 2rem;
  background: linear-gradient(135deg, #8b5cf6 0%, #7c3aed 100%);
  color: white;
  border: none;
  border-radius: 8px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
}

.rsvp-button:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(139, 92, 246, 0.3);
}
</style>