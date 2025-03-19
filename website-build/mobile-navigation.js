const primaryNav = document.querySelector('.primary-navigation');
const navToggle = document.querySelector('.mobile-nav-toggle');


navToggle.addEventListener("click", () => {
    const visibility = primaryNav.getAttribute('data-visible');
    if (visibility === "false") {
        primaryNav.setAttribute("data-visible", true);
        navToggle.setAttribute('aria-expanded', true);
    }else if (visibility === "true"){
        primaryNav.setAttribute("data-visible", false)
        navToggle.setAttribute('aria-expanded', false);
       
    }
    
});


document.addEventListener("click", (e) => {
    const isClickInside = primaryNav.contains(e.target) || navToggle.contains(e.target);

    if (!isClickInside) {
        primaryNav.setAttribute("data-visible", "false");
        navToggle.setAttribute("aria-expanded", "false");
    }
});