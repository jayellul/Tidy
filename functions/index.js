// The Cloud Functions for Firebase SDK to create Cloud Functions and setup triggers.
const functions = require('firebase-functions');

// The Firebase Admin SDK to access the Firebase Realtime Database.
const admin = require('firebase-admin');
admin.initializeApp();


exports.tookOutGarbage = functions.https.onCall((data, context) => {
	// params
	const id = data.id;
	// promises 
	const namePromise = admin.database().ref('users/' + id).once('value');
	const tokensPromise = admin.database().ref('garbage/').once('value');
	let tokens; 
	let name = '';
	let tokensArray;
	return Promise.all([namePromise, tokensPromise]).then(results => {
		let nameSnapshot = results[0];
		let tokensSnapshot = results[1];
		if (nameSnapshot.exists()) {
			name = nameSnapshot.val();
			console.log(name);
		}
		// Notification payload
        const payload = {
          notification: {
            title: '',
            body: name + ' took out the Garbage.'
          }
	    };
		if (tokensSnapshot.exists()) {
			tokensArray = tokensSnapshot.val();
			console.log(tokensArray);
			tokensArray = Object.keys(tokensArray);
			tokensArray = tokensArray.filter(snapshot => snapshot !== id);
		}
		console.log(name + ' ' + id + ' ' + tokensArray);
		return admin.messaging().sendToDevice(tokensArray, payload);
	});

});

exports.remindGarbage = functions.https.onCall((data, context) => {
	// params
	const id = data.id;
	const sendTo = data.sendTo;
	let name = '';
	// promises 
	return admin.database().ref('users/' + id).once('value').then(snapshot => {
		if (snapshot.exists()) {
			name = snapshot.val();
		}
		// Notification payload
        const payload = {
          notification: {
            title: '',
            body: name + ' wants you to take out the Garbage.'
          }
	    };
	    let sendDevices = [sendTo];
	    console.log(name + '   ' + sendDevices);
		return admin.messaging().sendToDevice(sendDevices, payload);
	});
});


exports.tookOutRecycling = functions.https.onCall((data, context) => {
	// params
	const id = data.id;
	// promises 
	const namePromise = admin.database().ref('users/' + id).once('value');
	const tokensPromise = admin.database().ref('recycling/').once('value');
	let tokens; 
	let name = '';
	let tokensArray;
	return Promise.all([namePromise, tokensPromise]).then(results => {
		let nameSnapshot = results[0];
		let tokensSnapshot = results[1];
		if (nameSnapshot.exists()) {
			name = nameSnapshot.val();
			console.log(name);
		}
		// Notification payload
        const payload = {
          notification: {
            title: '',
            body: name + ' took out the Recycling.'
          }
	    };
		if (tokensSnapshot.exists()) {
			tokensArray = tokensSnapshot.val();
			console.log(tokensArray);
			tokensArray = Object.keys(tokensArray);
			tokensArray = tokensArray.filter(snapshot => snapshot !== id);
		}
		console.log(name + ' ' + id + ' ' + tokensArray);
		return admin.messaging().sendToDevice(tokensArray, payload);
	});

});

exports.remindRecycling = functions.https.onCall((data, context) => {
	// params
	const id = data.id;
	const sendTo = data.sendTo;
	let name = '';
	// promises 
	return admin.database().ref('users/' + id).once('value').then(snapshot => {
		if (snapshot.exists()) {
			name = snapshot.val();
		}
		// Notification payload
        const payload = {
          notification: {
            title: '',
            body: name + ' wants you to take out the Recycling.'
          }
	    };
	    // can work with array or just string
	    let sendDevices = sendTo;
	    console.log(name + '   ' + sendDevices);
		return admin.messaging().sendToDevice(sendDevices, payload);
	});
});
