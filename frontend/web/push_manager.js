const VAPID_PUBLIC_KEY = 'BKSgCFXWk1XzkgmLbPI_3FGQGQrGYjVP1LjGZwbhmm11C1na4NmPaitNUT_exYV0luXkmTHWRVfacTv_jnq4jB4';

function urlBase64ToUint8Array(base64String) {
    const padding = '='.repeat((4 - base64String.length % 4) % 4);
    const base64 = (base64String + padding)
        .replace(/\-/g, '+')
        .replace(/_/g, '/');

    const rawData = window.atob(base64);
    const outputArray = new Uint8Array(rawData.length);

    for (let i = 0; i < rawData.length; ++i) {
        outputArray[i] = rawData.charCodeAt(i);
    }
    return outputArray;
}

window.subscribeUserToPush = async function () {
    if (!('serviceWorker' in navigator) || !('PushManager' in window)) {
        console.warn('Push messaging is not supported');
        return null;
    }

    try {
        const registration = await navigator.serviceWorker.ready;

        // Check if subscription already exists
        let subscription = await registration.pushManager.getSubscription();

        if (subscription) {
            return subscription;
        }

        // Request permission
        const permission = await Notification.requestPermission();
        if (permission !== 'granted') {
            throw new Error('Permission not granted for notifications');
        }

        // Subscribe
        const subscribeOptions = {
            userVisibleOnly: true,
            applicationServerKey: urlBase64ToUint8Array(VAPID_PUBLIC_KEY)
        };

        subscription = await registration.pushManager.subscribe(subscribeOptions);
        console.log('User is subscribed:', subscription);
        return subscription;
    } catch (error) {
        console.error('Failed to subscribe the user: ', error);
        return null;
    }
};

window.unsubscribeUserFromPush = async function () {
    if (!('serviceWorker' in navigator)) return;

    try {
        const registration = await navigator.serviceWorker.ready;
        const subscription = await registration.pushManager.getSubscription();

        if (subscription) {
            await subscription.unsubscribe();
            return subscription.endpoint;
        }
    } catch (error) {
        console.error('Error unsubscribing', error);
    }
    return null;
};
