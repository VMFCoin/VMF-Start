document.querySelectorAll('.copy').forEach(function(button) {
    button.addEventListener('click', function() {
        // Get the address span associated with the clicked button
        var address = this.previousElementSibling.textContent.trim(); // the <span class="address"> element
        
        // Copy the address to the clipboard
        navigator.clipboard.writeText(address)
            .then(function() {
                alert("Copied the text: " + address); // Show success message
            })
            .catch(function(error) {
                alert("Failed to copy text: " + error); // Show error if any
            });
    });
});