[osadmin@dvme11daa01noi config]$ view wforce_config.lua

[3]+  Stopped                 view wforce_config.lua
[osadmin@dvme11daa01noi config]$ cat wforce_config.lua
local wforce = require("policy.wforce")
local utils = require("policy.utils")
local wl = require("config.wforce_wl")

local wforce_config = {
   -- possible actions are "reject", "log", "tarpit", "blacklistip", "blacklistlogin", "blacklistiplogin"
   wforce_default_action = "reject",
   wforce_default_action_value = "",
   wforce_1hr_policies = {
      maxDiffBadPasswordsPerIP = {
         enabled = true,
         threshold = 30,
         policy_code = 501,
         policy_text = "maxDiffBadPasswordsPerIP"
      },
      maxDiffBadPasswordsPerUser = {
         enabled = true,
         threshold = 9,
         policy_code = 502,
         policy_text = "maxDiffBadPasswordsPerUser"
      },
      maxDiffBadPasswordsPerIPUser = {
         enabled = true,
         threshold = 3,
         action = "tarpit",
         action_value = 5,
         policy_code = 503,
         policy_text = "maxDiffBadPasswordsPerIPUser"
      },
      maxDiffIPsPerUser = {
         enabled = true,
         threshold = 10,
         policy_code = 511,
         policy_text = "maxDiffIPsPerUser"
      },
      maxDiffLoginsPerIP = {
         enabled = true,
         threshold = 20,
         policy_code = 512,
         policy_text = "maxDiffLoginsPerIP"
      },
      maxLoginsPerIP = {
         enabled = true,
         threshold = 600,
         action = "tarpit",
         action_value = 5,
         policy_code = 521,
         policy_text = "maxLoginsPerIP"
      },
      maxLoginsPerUser = {
         enabled = true,
         threshold = 240,
         action = "tarpit",
         action_value = 5,
         policy_code = 522,
         policy_text = "maxLoginsPerUser"
      },
      maxFailedLoginsPerIP = {
         enabled = true,
         threshold = 300,
         action = "tarpit",
         action_value = 5,
         policy_code = 531,
         policy_text = "maxFailedLoginsPerIP"
      },
      maxFailedLoginsPerUser = {
         enabled = true,
         threshold = 120,
         action = "tarpit",
         action_value = 5,
         policy_code = 532,
         policy_text = "maxFailedLoginsPerUser"
      },
      maxDiffCountriesPerUser = {
         enabled = true,
         threshold = 3,
         action = "reject",
         policy_code = 541,
         policy_text = "maxDiffCountriesPerUser"
      }
   },
   wforce_24hr_policies = {
      maxRejectsPerHourPerIP = {
         enabled = true,
         threshold = 60,
         action = "blacklistip",
         action_value = 3600,
         policy_code = 1001,
         policy_text = "maxRejectsPerHourPerIP"
      },
      maxRejectsPerHourPerUser = {
         enabled = true,
         threshold = 30,
         action = "blacklistlogin",
         action_value = 3600,
         policy_code = 1002,
         policy_text = "maxRejectsPerHourPerUser"
      },
      maxRejectsPerHourPerIPUser = {
         enabled = true,
         threshold = 15,
         action = "blacklistiplogin",
         action_value = 3600,
         policy_code = 1003,
         policy_text = "maxRejectsPerHourPerIPUser"
      },
      maxRejectsPerDayPerIP = {
         enabled = true,
         threshold = 200,
         action = "blacklistip",
         action_value = 86400, -- blacklist for a whole day
         policy_code = 1004,
         policy_text = "maxRejectsPerDayPerIP"
      },
      maxRejectsPerDayPerUser = {
         enabled = true,
         threshold = 100,
         action = "blacklistlogin",
         action_value = 86400, -- blacklist for a whole day
         policy_code = 1005,
         policy_text = "maxRejectsPerDayPerUser"
      },
      maxRejectsPerDayPerIPUser = {
         enabled = true,
         threshold = 50,
         action = "blacklistiplogin",
         action_value = 86400, -- blacklist for a whole day
         policy_code = 1006,
         policy_text = "maxRejectsPerDayPerIPUser"
      }
   },
   general_policies = {
      countryBlacklist = {
         enabled = true,
         policy_params = {}, -- Add a comma-separated list of 2-digit country codes that will be blacklisted
         action = "reject",
         policy_code = 551,
         policy_text = "countryBlacklist"
      }
   },
   -- Change this to true if you want to use RBLs
   wforce_enable_rbls = false,
   -- Define used RBLs here
   -- format is user-friendly-name = { zone="rblzone.example",
   -- ret={ "127.0.0.2", "127.0.0.3" }, msg = "Your message to the client" }
   wforce_rbls = {
      spamhaus =
      { zone = "pbl.spamhaus.org", -- you would NEVER use this for real
        ret = { "127.0.0.10" },
        msg = "Your IP address is on the spamhaus blacklist, please visit https://www.spamhaus.org/lookup/"
      },
      mybl =
         { zone = "myisp.bl",
           ret = { "127.0.0.2", "127.0.0.3" },
           msg = "You have been blacklisted by myzone, please contact myisp support at https://myisp.net/support/blacklist"
         }
   },
   -- Set up the address of your rbldnsd server here
   wforce_rbldnsd_addr = "127.0.0.1",
   wforce_rbldnsd_port = 5353,
   -- use these hooks to run your own functions before report/allow
   report_prefunc = nil,
   allow_prefunc = nil,
   allow_postfunc = nil,
   -- Change this to turn on debug logging - warning this is very voluminous
   debugLog = false,
   diffCountryWL = {}, -- Add comma-separated list of 2-digit country codes that will not be tracked, e.g. { "FR", "US" },
   replicationEnabled = true -- Replicate stats DBs?
}

local function initConfig(newconfig)
   utils.mergeTables(wforce_config, newconfig)
   wforce.init(wforce_config)
end

local function initDomainConfig(domain, newconfig)
   local tmpconfig = {}
   utils.mergeTables(tmpconfig, wforce_config)
   utils.mergeTables(tmpconfig, newconfig)
   wforce.initDomain(domain, tmpconfig)
end

return {
   loadWhitelists = wl.loadWhitelists,
   loadWhitelistsFromFile = wl.loadWhitelistsFromFile,
   initConfig = initConfig,
   initDomainConfig = initDomainConfig
}
[osadmin@dvme11daa01noi config]$
