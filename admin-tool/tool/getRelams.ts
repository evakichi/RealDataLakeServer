import axios from 'axios';

//const axios = require('axios'); // legacy way

console.log(process.env);

const params={
	client_id:"admin-cli",
	username:process.env.KEYCLOAK_ADMIN,
	password:process.env.KEYCLOAK_ADMIN_PASSWORD,
	grant_type:"password"

}
const headers={
		  'Content-Type':'application/x-www-form-urlencoded'
}
axios.post('https://lets-note.lan:8443/realms/master/protocol/openid-connect/token',params,{headers:headers})
  .then(response => {
    console.log(response.data);
    const params={
	    realm:"MinIORealm",
	    enabled:true,
    };
    const headers={
	    'Authorization': `bearer ${response.data.access_token}`,
	    'Content-Type':'application/json'
    };
    axios.post('https://lets-note.lan:8443/admin/realms',params,{headers:headers})
  })
  .catch(error => {
    console.error(error);
  });
