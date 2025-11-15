<template>
  <div class="upload-btn-wrapper">
    <input
      ref="fileInput"
      type="file"
      :accept="accept"
      :multiple="multiple"
      :disabled="disabled"
      @change="handleFileChange"
      style="display: none"
    />
    <button
      :class="['upload-btn', { disabled, 'has-files': files.length > 0 }]"
      :disabled="disabled"
      @click="openFilePicker"
    >
      <span class="upload-icon">📎</span>
      <span v-if="files.length === 0"><slot>Upload File</slot></span>
      <span v-else>{{ files.length }} file(s) selected</span>
    </button>
    <div v-if="files.length > 0" class="file-preview">
      <div v-for="(file, i) in files" :key="i" class="file-item">
        <span class="file-name">{{ file.name }}</span>
        <button class="remove-btn" @click="removeFile(i)">×</button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue';

interface Props {
  accept?: string;
  multiple?: boolean;
  disabled?: boolean;
}

withDefaults(defineProps<Props>(), {
  accept: '*',
  multiple: false,
  disabled: false
});

const emit = defineEmits<{
  change: [files: File[]];
}>();

const fileInput = ref<HTMLInputElement | null>(null);
const files = ref<File[]>([]);

const openFilePicker = () => {
  fileInput.value?.click();
};

const handleFileChange = (event: Event) => {
  const target = event.target as HTMLInputElement;
  if (target.files) {
    files.value = Array.from(target.files);
    emit('change', files.value);
  }
};

const removeFile = (index: number) => {
  files.value.splice(index, 1);
  emit('change', files.value);
};
</script>

<style scoped>
.upload-btn-wrapper {
  display: inline-block;
}

.upload-btn {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.875rem 1.5rem;
  font-size: 1rem;
  font-weight: 600;
  color: white;
  background: linear-gradient(135deg, #8b5cf6 0%, #7c3aed 100%);
  border: none;
  border-radius: 10px;
  cursor: pointer;
  transition: all 0.2s ease;
}

.upload-btn:hover:not(.disabled) {
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(139, 92, 246, 0.3);
}

.upload-btn.has-files {
  background: linear-gradient(135deg, #10b981 0%, #059669 100%);
}

.upload-btn.disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.file-preview {
  margin-top: 0.75rem;
  padding: 0.75rem;
  background: #f9fafb;
  border-radius: 8px;
}

.file-item {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0.5rem;
  background: white;
  border-radius: 6px;
  margin-bottom: 0.5rem;
}

.file-item:last-child {
  margin-bottom: 0;
}

.file-name {
  font-size: 0.875rem;
  color: #374151;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.remove-btn {
  width: 24px;
  height: 24px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #fee2e2;
  color: #ef4444;
  border: none;
  border-radius: 50%;
  cursor: pointer;
  font-size: 1.25rem;
  line-height: 1;
}

.remove-btn:hover {
  background: #fecaca;
}
</style>