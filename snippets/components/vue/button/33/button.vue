<template>
  <button
    :class="['qr-btn', { scanning, disabled }]"
    :disabled="disabled"
    @click="startScan"
  >
    <span class="qr-icon">📷</span>
    <span v-if="!scanning"><slot>Scan QR Code</slot></span>
    <span v-else>Scanning...</span>
    <div v-if="scanning" class="scanner">
      <div class="scan-line"></div>
    </div>
  </button>
</template>

<script setup lang="ts">
import { ref } from 'vue';

interface Props {
  disabled?: boolean;
}

withDefaults(defineProps<Props>(), {
  disabled: false
});

const emit = defineEmits<{
  scan: [result: string];
}>();

const scanning = ref(false);

const startScan = () => {
  if (!disabled) {
    scanning.value = true;
    
    // Simulate QR scan
    setTimeout(() => {
      scanning.value = false;
      emit('scan', 'QR_CODE_RESULT');
    }, 2000);
  }
};
</script>

<style scoped>
.qr-btn {
  position: relative;
  display: flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.875rem 1.5rem;
  font-size: 1rem;
  font-weight: 600;
  color: white;
  background: linear-gradient(135deg, #06b6d4 0%, #0891b2 100%);
  border: none;
  border-radius: 10px;
  cursor: pointer;
  transition: all 0.2s ease;
  overflow: hidden;
}

.qr-btn:hover:not(.disabled) {
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(6, 182, 212, 0.3);
}

.qr-btn.scanning {
  background: linear-gradient(135deg, #10b981 0%, #059669 100%);
}

.qr-btn.disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.scanner {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  pointer-events: none;
}

.scan-line {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 2px;
  background: rgba(255, 255, 255, 0.8);
  box-shadow: 0 0 8px rgba(255, 255, 255, 0.6);
  animation: scan 2s linear infinite;
}

@keyframes scan {
  0% {
    top: 0;
  }
  100% {
    top: 100%;
  }
}
</style>