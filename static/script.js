window.addEventListener('load', async () => {
  const connectWalletButton = document.getElementById('connect_wallet_button');
  connectWalletButton.addEventListener('click', async () => {

    await window.ethereum.enable();

    const accounts = await window.ethereum.request({ method: 'eth_accounts' });
    const address = accounts[0];

    const addressField = document.getElementById('recipient_address');
    addressField.value = address;
  });
});

function copyAdd() {
  navigator.clipboard.writeText("0x1Eabb226755A8C0969cDcBD4688F6501219773F2");

  // Get the modal
  var modal = document.getElementById("myModal");
  // Get the button that opens the modal
  var btn = document.getElementById("modal-button");
  // Get the <span> element that closes the modal
  var span = document.getElementsByClassName("close")[0];
  // User has already clicked the button, so open modal
  modal.style.display = "flex";
  // When the user clicks on <span> (x), close the modal
  span.onclick = function() {
  modal.style.display = "none";
  }

  //timer for 5 sec then modal will be auto closed
  setTimeout(function() {
    modal.style.display = "none";
  }, 5000);

  // When the user clicks anywhere outside of the modal, close it
  window.onclick = function(event) {
    if (event.target == modal) {
      modal.style.display = "none";
    }
  }
}


function copyText() {
  navigator.clipboard.writeText("0x2A83a8b3fF1eB31d348975878950D06Dd2add900");
  
  // Get the modal
  var modal = document.getElementById("myModal");
  // Get the button that opens the modal
  var btn = document.getElementById("modal-button");
  // Get the <span> element that closes the modal
  var span = document.getElementsByClassName("close")[0];
  // User has already clicked the button, so open modal
  modal.style.display = "flex";
  // When the user clicks on <span> (x), close the modal
  span.onclick = function() {
  modal.style.display = "none";
  }

  //timer for 5 sec then modal will be auto closed
  setTimeout(function() {
    modal.style.display = "none";
  }, 5000);

  // When the user clicks anywhere outside of the modal, close it
  window.onclick = function(event) {
    if (event.target == modal) {
      modal.style.display = "none";
    }
  }
}