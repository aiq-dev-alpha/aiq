<template>
  <div :class="['weather-card', weatherCondition]">
    <div class="current-weather">
      <div class="weather-icon">{{ getWeatherIcon(weatherCondition) }}</div>
      <div class="temperature">
        <span class="temp-value">{{ temperature }}</span>
        <span class="temp-unit">°{{ unit }}</span>
      </div>
      <div class="condition-text">{{ weatherCondition }}</div>
    </div>
    <div class="weather-details">
      <div class="detail-item">
        <span class="detail-icon">💨</span>
        <span class="detail-label">Wind</span>
        <span class="detail-value">{{ windSpeed }} mph</span>
      </div>
      <div class="detail-item">
        <span class="detail-icon">💧</span>
        <span class="detail-label">Humidity</span>
        <span class="detail-value">{{ humidity }}%</span>
      </div>
    </div>
    <div class="forecast">
      <div v-for="day in forecast" :key="day.day" class="forecast-day">
        <div class="day-name">{{ day.day }}</div>
        <div class="day-icon">{{ getWeatherIcon(day.condition) }}</div>
        <div class="day-temp">{{ day.temp }}°</div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
interface ForecastDay {
  day: string;
  temp: number;
  condition: string;
}

interface Props {
  temperature: number;
  weatherCondition: string;
  windSpeed: number;
  humidity: number;
  forecast: ForecastDay[];
  unit?: 'C' | 'F';
}

withDefaults(defineProps<Props>(), {
  unit: 'F'
});

const getWeatherIcon = (condition: string): string => {
  const icons: Record<string, string> = {
    sunny: '☀️',
    cloudy: '☁️',
    rainy: '🌧️',
    stormy: '⛈️',
    snowy: '❄️'
  };
  return icons[condition.toLowerCase()] || '🌤️';
};
</script>

<style scoped>
.weather-card {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: 24px;
  padding: 2rem;
  color: white;
  box-shadow: 0 10px 40px rgba(102, 126, 234, 0.3);
}

.weather-card.sunny {
  background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);
}

.weather-card.rainy {
  background: linear-gradient(135deg, #3b82f6 0%, #1d4ed8 100%);
}

.current-weather {
  text-align: center;
  margin-bottom: 2rem;
}

.weather-icon {
  font-size: 5rem;
  margin-bottom: 1rem;
}

.temperature {
  display: flex;
  align-items: flex-start;
  justify-content: center;
  gap: 0.5rem;
}

.temp-value {
  font-size: 4rem;
  font-weight: 700;
  line-height: 1;
}

.temp-unit {
  font-size: 2rem;
  margin-top: 0.5rem;
}

.condition-text {
  font-size: 1.5rem;
  margin-top: 1rem;
  text-transform: capitalize;
}

.weather-details {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 1rem;
  margin-bottom: 2rem;
  padding: 1.5rem;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 16px;
  backdrop-filter: blur(10px);
}

.detail-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0.5rem;
}

.detail-icon {
  font-size: 2rem;
}

.detail-label {
  font-size: 0.875rem;
  opacity: 0.9;
}

.detail-value {
  font-size: 1.125rem;
  font-weight: 700;
}

.forecast {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(80px, 1fr));
  gap: 1rem;
}

.forecast-day {
  text-align: center;
  padding: 1rem 0.5rem;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 12px;
}

.day-name {
  font-size: 0.875rem;
  margin-bottom: 0.5rem;
}

.day-icon {
  font-size: 2rem;
  margin: 0.5rem 0;
}

.day-temp {
  font-weight: 700;
}
</style>