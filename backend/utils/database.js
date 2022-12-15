const logger = require('./logger');
const database = require("../models");

module.exports = async function(isProduction) {

    logger.info("setting up Database");
    let params;
    if (!isProduction) {
        params = {force: true};
    }

    await database.sequelize.sync(params);

    logger.info("Database ready");
};