const hre = require("hardhat");

async function main() {
    const Voting = await hre.ethers.getContractFactory("Voting");
  
    
    const Voting_ = await Voting.deploy(["Park", "Otopark", "Kafe"], 20);

    await Voting_.waitForDeployment();

    console.log("Contract address:", Voting_.target);
  
  
  }
  
  main()
   .then(() => process.exit(0))
   .catch(error => {
     console.error(error);
     process.exit(1);
   });

   //Contract address: 0xCf15e43291512448fE2B6d34924c03307B0c2dba