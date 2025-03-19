const images = [
    'images/us-flag-3838582_1920.jpg',
    'images/pexels-nc-farm-bureau-mark-8576735.jpg',
    'images/pexels-sonneblom-457563.jpg',
];


const randomIndex = Math.floor(Math.random() * images.length);


document.documentElement.style.setProperty('--background-image', `url(${images[randomIndex]})`);