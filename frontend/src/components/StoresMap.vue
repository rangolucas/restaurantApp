<template>
  <div class="map-container">
    <div id="map"></div>
  </div>
</template>

<script>
import { Loader } from "@googlemaps/js-api-loader";

export default {
  name: "StoresMap",
  props: {
    stores: {
      type: Array,
      required: true,
    },
  },
  mounted() {
    const loader = new Loader({
      apiKey: "AIzaSyDgRY5NQGY3JwSGdpM8HMzLKBuZc9OqI2E", // Reemplaza con tu clave de API
      version: "weekly",
      libraries: ["places"], // Opcional: versión de la API
    });

    loader.load().then(() => {
      const initializeMap = (center) => {
        const map = new google.maps.Map(document.getElementById("map"), {
          center: center,
          zoom: 12, // Adjust the zoom level as needed
        });

        // Add markers for each store
        this.stores.forEach((store) => {
          const marker = new google.maps.Marker({
            position: { lat: store.lat, lng: store.long },
            map: map,
            title: store.id,
          });

          // Add click event listener to the marker
          marker.addListener('click', () => {
            const infoWindow = new google.maps.InfoWindow({
              content: `<div><strong>${store.id}</strong><br>${store.contact}</div>`,
            });
            infoWindow.open(map, marker);
          });
        });
      };

      if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(
          (position) => {
            const { latitude, longitude } = position.coords;
            initializeMap({ lat: latitude, lng: longitude });
          },
          (error) => {
            console.error("Error getting current location:", error);
            initializeMap({ lat: -34.588207, lng: -58.437899 }); // Default to Caba
          }
        );
      } else {
        console.error("Geolocation is not supported by this browser.");
        initializeMap({ lat: -34.588207, lng: -58.437899 }); // Default to Caba
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
