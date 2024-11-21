<script>
import { Loader } from "@googlemaps/js-api-loader"
import { DISTANCE_THRESHOLD } from '../constants'


const DEFAULT_COORDINATES = { lat: -34.588207, lng: -58.437899 } // CABA

const calculateDistance = (lat1, lng1, lat2, lng2) => {
  return (Math.sqrt(Math.pow(lat2 - lat1, 2) + Math.pow(lng2 - lng1, 2))) * 100;
};

export default {
  name: "StoresMap",
  props: {
    stores: {
      type: Array,
      required: true,
    },
  },
  methods: {
    initializeMapAndMarkers(center, stores) {
      const map = new google.maps.Map(document.getElementById("map"), {
        center: center,
        zoom: 12,
        mapId: "a68d2e12be21b6a3",
        mapTypeControl: false,
        streetViewControl: false,
      });

      // Add markers for each store
      stores.forEach((store) => {
        const distance = calculateDistance(center.lat, center.lng, store.lat, store.lng);
        const pinForFarStores = new google.maps.marker.PinElement({
          background: "grey",
          glyphColor: "white",
          borderColor: "grey"
        });
        const pinForCloseStores = new google.maps.marker.PinElement({
          background: "red",
          glyphColor: "white",
          borderColor: "red"
        });
        const marker = new google.maps.marker.AdvancedMarkerElement({
          map,
          position: { lat: store.lat, lng: store.lng },
          content: distance > DISTANCE_THRESHOLD ? pinForFarStores.element : pinForCloseStores.element,
        });

        // Add click event listener to the marker
        marker.addListener('click', () => {
          const infoWindow = new google.maps.InfoWindow({
            content: distance > DISTANCE_THRESHOLD ?
              `<div>
                <h6 style="color:grey;"><strong>${store.name}</strong></h6>
                ${store.address}
                <p>Horarios: ${store.hours}</p>
                <p>Distancia: ${distance.toFixed(2)} km</p>
              </div>` :
              `<div>
                <h6><strong><a href="#/user/${store.id}">${store.name}</a></strong></h6>
                <br>${store.address}
                <br><p>Horarios: ${store.hours}</p>
                <p>Distancia: ${distance.toFixed(2)} km</p>
              </div>`
          });
          infoWindow.open(map, marker);
        });
      });
    }
  },
  mounted() {
    const loader = new Loader({
      apiKey: "AIzaSyDgRY5NQGY3JwSGdpM8HMzLKBuZc9OqI2E",
      version: "weekly",
      libraries: ["places", "marker"],
    });

    loader.load().then(() => {
      if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(
          (position) => {
            const { latitude, longitude } = position.coords;
            this.initializeMapAndMarkers({ lat: latitude, lng: longitude }, this.stores);
          },
          (error) => {
            console.error("Error getting current location:", error);
            this.initializeMapAndMarkers(DEFAULT_COORDINATES, this.stores); // Default to CABA
          }
        );
      } else {
        console.error("Geolocation is not supported by this browser.");
        this.initializeMapAndMarkers(DEFAULT_COORDINATES, this.stores); // Default to CABA
      }
    });
  },
  watch: {
    stores(newStores) {
      const loader = new Loader({
        apiKey: "AIzaSyDgRY5NQGY3JwSGdpM8HMzLKBuZc9OqI2E",
        version: "weekly",
        libraries: ["places", "marker"],
      });

      loader.load().then(() => {
        if (navigator.geolocation) {
          navigator.geolocation.getCurrentPosition(
            (position) => {
              const { latitude, longitude } = position.coords;
              this.initializeMapAndMarkers({ lat: latitude, lng: longitude }, newStores);
            },
            (error) => {
              console.error("Error getting current location:", error);
              this.initializeMapAndMarkers(DEFAULT_COORDINATES, newStores); // Default to CABA
            }
          );
        } else {
          console.error("Geolocation is not supported by this browser.");
          this.initializeMapAndMarkers(DEFAULT_COORDINATES, newStores); // Default to CABA
        }
      });
    },
  },
};
</script>

<template>
  <div class="map-container">
    <div id="map"></div>
  </div>
</template>

<style scoped>
.map-container {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 500px;
  width: 80%;
  margin: 0 auto;
  padding: 20px;
}

#map {
  height: 100%;
  width: 100%;
}
</style>
