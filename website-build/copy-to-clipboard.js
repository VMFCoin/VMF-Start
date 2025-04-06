document.querySelectorAll('.copy').forEach(function(button) {
    button.addEventListener('click', function() {
        var address = this.previousElementSibling.textContent.trim(); 

        navigator.clipboard.writeText(address)
            .then(function() {
                alert("Copied: " + address);
            })
            .catch(function(error) {
                alert("Failed to copy text: " + error);
            });
    });
});