<template>
  <v-card 
    class="stat-card" 
    :class="{'stat-card-hover': hover}"
    elevation="2"
    @mouseenter="hover = true"
    @mouseleave="hover = false"
  >
    <v-card-text class="pa-5">
      <div class="d-flex align-center justify-space-between mb-3">
        <v-icon :color="color" size="48" class="stat-icon">
          {{ icon }}
        </v-icon>
        <v-chip
          v-if="trend"
          :color="trendColor"
          size="small"
          class="trend-chip"
        >
          <v-icon start size="small">
            {{ trendIcon }}
          </v-icon>
          {{ trend }}
        </v-chip>
      </div>
      
      <div class="stat-value">{{ value }}</div>
      <div class="stat-label">{{ label }}</div>
      
      <v-progress-linear
        v-if="showProgress"
        :model-value="progress"
        :color="color"
        height="4"
        rounded
        class="mt-3"
      ></v-progress-linear>
      
      <div v-if="subtitle" class="stat-subtitle mt-2">
        {{ subtitle }}
      </div>
    </v-card-text>
  </v-card>
</template>

<script>
export default {
  name: 'StatCard',
  props: {
    icon: {
      type: String,
      required: true
    },
    value: {
      type: [String, Number],
      required: true
    },
    label: {
      type: String,
      required: true
    },
    color: {
      type: String,
      default: 'primary'
    },
    trend: {
      type: String,
      default: null
    },
    trendUp: {
      type: Boolean,
      default: true
    },
    progress: {
      type: Number,
      default: 0
    },
    showProgress: {
      type: Boolean,
      default: false
    },
    subtitle: {
      type: String,
      default: null
    }
  },
  data() {
    return {
      hover: false
    }
  },
  computed: {
    trendColor() {
      return this.trendUp ? 'success' : 'error'
    },
    trendIcon() {
      return this.trendUp ? 'mdi-trending-up' : 'mdi-trending-down'
    }
  }
}
</script>

<style scoped>
.stat-card {
  transition: all 0.3s ease;
  border-radius: 16px;
  overflow: hidden;
  position: relative;
  border-top: 4px solid #8bc34a;
  background: linear-gradient(135deg, #ffffff 0%, #f8fafb 100%);
}

.stat-card-hover {
  transform: translateY(-6px);
  box-shadow: 0 12px 32px rgba(139, 195, 74, 0.2) !important;
}

.stat-icon {
  opacity: 0.85;
  transition: all 0.3s ease;
  filter: drop-shadow(0 2px 4px rgba(0, 0, 0, 0.1));
}

.stat-card:hover .stat-icon {
  transform: scale(1.15) rotate(5deg);
  opacity: 1;
}

.stat-value {
  font-size: 2.25rem;
  font-weight: 800;
  line-height: 1.2;
  background: linear-gradient(135deg, #8bc34a 0%, #5fc2c6 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  margin-bottom: 4px;
}

.stat-label {
  font-size: 0.875rem;
  color: #2c3e50;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.8px;
}

.stat-subtitle {
  font-size: 0.8rem;
  color: #7f8c8d;
  font-weight: 500;
}

.trend-chip {
  font-weight: 600;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

/* Colores personalizados según la paleta NutriTrack */
:deep(.v-icon.text-primary),
:deep(.v-progress-linear.bg-primary) {
  color: #8bc34a !important;
}

:deep(.v-icon.text-success) {
  color: #5fc2c6 !important;
}

:deep(.v-icon.text-orange) {
  color: #ff5252 !important;
}

:deep(.v-icon.text-purple) {
  color: #7a7a5a !important;
}
</style>
