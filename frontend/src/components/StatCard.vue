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
  border-radius: 12px;
  overflow: hidden;
  position: relative;
}

.stat-card-hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 24px rgba(0,0,0,0.12) !important;
}

.stat-icon {
  opacity: 0.9;
  transition: transform 0.3s ease;
}

.stat-card:hover .stat-icon {
  transform: scale(1.1);
}

.stat-value {
  font-size: 2rem;
  font-weight: 700;
  line-height: 1.2;
  color: #2c3e50;
  margin-bottom: 4px;
}

.stat-label {
  font-size: 0.875rem;
  color: #7f8c8d;
  font-weight: 500;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.stat-subtitle {
  font-size: 0.8rem;
  color: #95a5a6;
}

.trend-chip {
  font-weight: 600;
}
</style>
