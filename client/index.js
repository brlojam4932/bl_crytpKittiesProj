alert("Hello");








//-------------------------------

// 1 Basic Action(Part 1)

const forwarderOrigin = 'http://localhost:7545';

const initialize = () => {
  //You will start here
  
  const onboardButton = document.getElementById('connectButton');
  const getAccountsButton = document.getElementById('getAccounts');
  const getAccountsResult = document.getElementById('getAccountsResult');
  const showBalance = document.getElementById('showbalance')

  //Created check function to see if the MetaMask extension is installed
  const isMetaMaskInstalled = () => {
    //Have to check the ethereum binding on the window object to see if it's installed
    const { ethereum } = window;
    return Boolean(ethereum && ethereum.isMetaMask);
  };

  //We create a new MetaMask onboarding object to use in our app
  //import MetaMaskOnboarding from '@metamask/onboarding';
 /*
  import MetaMaskOnboarding from '@metamask/onboarding';
  const onboarding = new MetaMaskOnboarding({ forwarderOrigin });

  //This will start the onboarding proccess
  const onClickInstall = () => {
    onboardButton.innerText = 'Onboarding in progress';
    onboardButton.disabled = true;
    //On this object we have startOnboarding which will start the onboarding process for our end user
    onboarding.startOnboarding();
  };
  */

  var instance;
  var user;
  var contractAddress = 0x51d9aD5C5EB7FDBB444D78ADE2a194f87dcEf735;;

  $(document).ready(async () => {
   
    const accounts = await ethereum.request({from: accounts[0], abi, contractAddress, method: 'eth_requestAccounts' })
    // Accounts now exposed, use them

      user = accounts[0];

      console.log(instance);

      instance.methods
  }) 


  const onClickConnect = async () => {
    try {
      // Will open the MetaMask UI
      // You should disable this button while the request is pending!
      await ethereum.request({ method: 'eth_requestAccounts' });
    } catch (error) {
      console.error(error);
    }
  };

  //------Inserted Code------\\
  const MetaMaskClientCheck = () => {
    //Now we check to see if Metmask is installed
    if (!isMetaMaskInstalled()) {
      //If it isn't installed we ask the user to click to install it
      onboardButton.innerText = 'Click here to install MetaMask!';
      //When the button is clicked we call this function
      onboardButton.onclick = onClickInstall;
      
      //The button is now disabled
      onboardButton.disabled = false;
    } else {
      //If it is installed we change our button text
      onboardButton.innerText = 'Connect';
       //When the button is clicked we call this function to connect the users MetaMask Wallet
      onboardButton.onclick = onClickConnect;
      //The button is now disabled
      onboardButton.disabled = false;
    }
  };
  MetaMaskClientCheck();
  //------/Inserted Code------\\

  // last step, grab data
  //Eth_Accounts-getAccountsButton
  getAccountsButton.addEventListener('click', async () => {
    //we use eth_accounts because it returns a list of addresses owned by us.
    const accounts = await ethereum.request({ method: 'eth_accounts' });
    //We take the first address in the array of addresses and display it
    getAccountsResult.innerHTML = accounts[0] || 'Not able to get accounts';

    const balance = await ethereum.request({ method: 'eth_getBalance', params: [accounts, 'latest'] });
    const read = parseInt[balance] / 10**18; // ten to the 18th power
    //console.log((read.toFixed(5)));
    showBalance.innerHTML = read.toFixed(5) || 'Not able to get accounts'
  });


};
window.addEventListener('DOMContentLoaded', initialize);





