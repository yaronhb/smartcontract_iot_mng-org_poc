const MyLightsController = artifacts.require('MyLightsController')

module.exports = async (callback) => {
  try {
    const myLightsController = await MyLightsController.deployed()
    const reciept = await myLightsController.doIteration()
    console.log(reciept)
  } catch(err) {
    console.log('Oops: ', err.message);
  }
  callback();
};
