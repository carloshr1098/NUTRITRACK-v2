<template>
  <div class="weight-chart-container">
    <h3 style="text-align: center; margin-bottom: 20px;">📊 Evolución del Peso</h3>
    <Line :data="chartData" :options="chartOptions" />
  </div>
</template>

<script>
import { Line } from 'vue-chartjs'
import { Chart as ChartJS, CategoryScale, LinearScale, PointElement, LineElement, Title, Tooltip, Legend, Filler } from 'chart.js'

ChartJS.register(CategoryScale, LinearScale, PointElement, LineElement, Title, Tooltip, Legend, Filler)

export default {
  name: 'WeightChart',
  components: { Line },
  props: {
    weightRecords: {
      type: Array,
      required: true,
      default: () => []
    }
  },
  computed: {
    chartData() {
      const labels = this.weightRecords.map(record => {
        const date = new Date(record.recordDate)
        return date.toLocaleDateString('es-MX', { day: '2-digit', month: 'short' })
      })
      
      const data = this.weightRecords.map(record => record.weight)
      
      return {
        labels: labels,
        datasets: [
          {
            label: 'Peso (kg)',
            data: data,
            borderColor: '#4CAF50',
            backgroundColor: 'rgba(76, 175, 80, 0.1)',
            tension: 0.4,
            fill: true,
            pointRadius: 6,
            pointHoverRadius: 8,
            pointBackgroundColor: '#4CAF50',
            pointBorderColor: '#fff',
            pointBorderWidth: 2
          }
        ]
      }
    },
    chartOptions() {
      return {
        responsive: true,
        maintainAspectRatio: true,
        plugins: {
          legend: {
            display: true,
            position: 'top'
          },
          tooltip: {
            callbacks: {
              label: function(context) {
                return 'Peso: ' + context.parsed.y + ' kg'
              }
            }
          }
        },
        scales: {
          y: {
            beginAtZero: false,
            ticks: {
              callback: function(value) {
                return value + ' kg'
              }
            },
            title: {
              display: true,
              text: 'Peso (kg)'
            }
          },
          x: {
            title: {
              display: true,
              text: 'Fecha'
            }
          }
        }
      }
    }
  }
}
</script>

<style scoped>
.weight-chart-container {
  background: white;
  padding: 20px;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
  margin: 20px 0;
}
</style>
