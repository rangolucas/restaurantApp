<script setup>
import { ref, onMounted } from 'vue'
import QRCode from 'qrcode'

const props = defineProps({
  url: {
    type: String,
    required: true,
  },
})

const qrCanvas = ref(null)

const generateQrCode = async () => {
  if (qrCanvas.value) {
    QRCode.toCanvas(qrCanvas.value, props.url, { width: 300 }, error => {
      if (error) {
        console.error('Error generating QR code:', error)
      }
    })
  }
}

onMounted(generateQrCode)
</script>

<template>
  <div>
    <canvas ref="qrCanvas"></canvas>
  </div>
</template>

<style scoped></style>
