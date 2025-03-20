const images = [
    'images/section-one-bg-one.jpg',
    'images/section-one-bg-two2.jpg',
    'images/section-one-bg-three.jpg',
];


const randomIndex = Math.floor(Math.random() * images.length);


document.documentElement.style.setProperty('--background-image', `url(${images[randomIndex]})`);