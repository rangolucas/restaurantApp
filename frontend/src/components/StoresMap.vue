<template>
  <div class="map-container">
    <div id="map"></div>
  </div>
</template>

<script>
import { Loader } from "@googlemaps/js-api-loader";

export default {
  name: "StoresMap",
  mounted() {
    const loader = new Loader({
      apiKey: "AIzaSyDgRY5NQGY3JwSGdpM8HMzLKBuZc9OqI2E", // Reemplaza con tu clave de API
      version: "weekly", // Opcional: versión de la API
    });

    loader.load().then(() => {
      if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(
          (position) => {
            const { latitude, longitude } = position.coords;
            const map = new google.maps.Map(document.getElementById("map"), {
              center: { lat: latitude, lng: longitude },
              zoom: 10,
            });

            // Agregar un marcador en la ubicación actual
            new google.maps.Marker({
              position: { lat: latitude, lng: longitude },
              map: map,
              title: "You are here!",
            });
          },
          () => {
            // Handle error case
            const map = new google.maps.Map(document.getElementById("map"), {
              center: { lat: -34.588207, lng: -58.437899 }, // Default to Caba
              zoom: 10,
            });

            // Agregar un marcador en la ubicación predeterminada
            new google.maps.Marker({
              position: { lat: -34.588207, lng: -58.437899 },
              map: map,
              title: "Default Location",
            });
          }
        );
      }
    });
  },
};
</script>

<style scoped>
.map-container {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 400px; /* Adjust the height as needed */
  width: 80%; /* Adjust the width as needed */
  margin: 0 auto;
  padding: 20px; /* Add padding as needed */
}

#map {
  height: 100%;
  width: 100%;
}
</style>
