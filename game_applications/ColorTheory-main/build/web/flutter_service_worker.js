'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter_bootstrap.js": "e497a84f0a97d609805df4e0a15512f8",
"version.json": "2e443b658799249574389c88490505ea",
"index.html": "4cb0f1bdd8914aca7ce2d67d466e1051",
"/": "4cb0f1bdd8914aca7ce2d67d466e1051",
"main.dart.js": "2cb2f51fcd0cc766ca569b272724fcf3",
"flutter.js": "83d881c1dbb6d6bcd6b42e274605b69c",
"favicon.png": "2704101cb06ce66e2000356a312be25c",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/app_launcher_icon.png": "3d8115ae5e659e5930ed60b5297174f8",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"assets/AssetManifest.json": "74b29ca08641a1ec8cb96249d198565a",
"assets/NOTICES": "f710a31ea28d7cc54bb57b7c5ffb9139",
"assets/FontManifest.json": "2a965526b17178742fa9e3ba4af309d4",
"assets/AssetManifest.bin.json": "46ab6bd0f7beac76487574d4c2429248",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/packages/font_awesome_flutter/lib/fonts/fa-solid-900.ttf": "04f83c01dded195a11d21c2edf643455",
"assets/packages/font_awesome_flutter/lib/fonts/fa-regular-400.ttf": "f3307f62ddff94d2cd8b103daf8d1b0f",
"assets/packages/font_awesome_flutter/lib/fonts/fa-brands-400.ttf": "17ee8e30dde24e349e70ffcdc0073fb0",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin": "99359a4a3b81380a528a156ce4eeb7cf",
"assets/fonts/MaterialIcons-Regular.otf": "c0ad29d56cfe3890223c02da3c6e0448",
"assets/assets/colortheory/audios/Brown.mp3": "5ccf0f342dbd57a261994c76eaac20ef",
"assets/assets/colortheory/audios/Red.mp3": "d51a9e8c0da86215ecd22febbaaaf7bf",
"assets/assets/colortheory/audios/Purple.mp3": "400ea5e3120890bfc8373601ef6f67b4",
"assets/assets/colortheory/audios/Rojo.mp3": "624edab6d38b3af146271e5f6c9e65bb",
"assets/assets/colortheory/audios/Verde.mp3": "8f6f187919c00fd798cb1f865bc834b7",
"assets/assets/colortheory/audios/Azul.mp3": "264f248a90a14f9a45e92dd51e29d31a",
"assets/assets/colortheory/audios/Green.mp3": "45c6df6cde196079fc387ce08f73d504",
"assets/assets/colortheory/audios/Orange.mp3": "a74fc0002721283674d7c36b735c300f",
"assets/assets/colortheory/audios/crash.mp3": "a4b9f502bc8c95b2290846e151982190",
"assets/assets/colortheory/audios/Pink.mp3": "3aeff39d28dc4d4e4c010a1f514a6986",
"assets/assets/colortheory/audios/Blue.mp3": "1e73a29b96546385135c03486f6d30ec",
"assets/assets/colortheory/audios/Amarillo.mp3": "e9e8ed3061a39ec0a0283078a8d1cc7a",
"assets/assets/colortheory/audios/favicon.png": "5dcef449791fa27946b3d35ad8803796",
"assets/assets/colortheory/audios/Yellow.mp3": "45dc14c7243a6dcd84d0e9fee26361c0",
"assets/assets/colortheory/audios/Morado.mp3": "127a3b2a06a6d1be293cfa7c8707c6fd",
"assets/assets/colortheory/audios/Marron.mp3": "31490a71c4faefcc7a15f17e22b938ed",
"assets/assets/colortheory/audios/main-menu-bg-final.mp3": "c905b83316b3ac6419ec8b4afb5385d6",
"assets/assets/colortheory/audios/game-over-final.mp3": "e3348057b43209cf78b20e94ebb0590c",
"assets/assets/colortheory/audios/Rosa.mp3": "adc177ed62fdeff03e87c09504fb96f4",
"assets/assets/colortheory/audios/main-menu-bg.mp3": "7314ed3f996d5ccb8329391e809551cb",
"assets/assets/colortheory/audios/crash-3.mp3": "bc7a91bcf42487edc8ad1dda6ae9d55c",
"assets/assets/colortheory/audios/Naranja.mp3": "a666f3ae05f1d7582da36a7f121ffcfe",
"assets/assets/colortheory/audios/crash-2.mp3": "5bcde930dc51cfdbb22cc3954c218d83",
"assets/assets/colortheory/jsons/favicon.png": "5dcef449791fa27946b3d35ad8803796",
"assets/assets/colortheory/rive_animations/favicon.png": "5dcef449791fa27946b3d35ad8803796",
"assets/assets/colortheory/images/lava.png": "9de372a7c22e30a72a5460321592a422",
"assets/assets/colortheory/images/mushroom.png": "2e19313278009fc4ab9b8ecbfd382a23",
"assets/assets/colortheory/images/lava-final.png": "1cb49795788456701648b6cf2c624aae",
"assets/assets/colortheory/images/bomb.png": "147a33ef29d083cdc3260db1747f858a",
"assets/assets/colortheory/images/dino-final.png": "9251b35bfe9c7bc14b2173429613b67f",
"assets/assets/colortheory/images/clouds.png": "816feb412f4ab77fe65834d763f288d4",
"assets/assets/colortheory/images/cactus.png": "f48b87d80029180161f45ba477df8025",
"assets/assets/colortheory/images/cloud-final.png": "a9287b3565f97cfddc1b7cfe31705ba3",
"assets/assets/colortheory/images/dino.png": "c2b84f8af981b8b2902b7935ce1fb3fc",
"assets/assets/colortheory/images/wood.png": "f63243745a14bac2e07f61aad0baec24",
"assets/assets/colortheory/images/app_launcher_icon.png": "3d8115ae5e659e5930ed60b5297174f8",
"assets/assets/colortheory/images/color_theory_trans_icon.png": "cafe4e163355095699b9e19cc0360b75",
"assets/assets/colortheory/images/color_theory_trans_icon.jpeg": "bb80edc80dbc11e7ffddf29c4e40d783",
"assets/assets/colortheory/images/favicon.png": "5dcef449791fa27946b3d35ad8803796",
"assets/assets/colortheory/images/flame.png": "c88ef524a38331f415a3f752702912ec",
"assets/assets/colortheory/images/wave.png": "995237135bf2be28e64232b1b0222192",
"assets/assets/colortheory/images/color_theory_icon.png": "3d8115ae5e659e5930ed60b5297174f8",
"assets/assets/colortheory/images/bomb-final.png": "83fcf95a95c33cca0325881eec15a08c",
"assets/assets/colortheory/images/ground.png": "4e759ea9c2dc5cf75ad6f3c573e21ec7",
"assets/assets/colortheory/images/color_theory_trans_icon-final.png": "b4d2a50d02991e42c95aac47559b7823",
"assets/assets/colortheory/images/snake.png": "8501d58a9754873878977265b2358046",
"assets/assets/colortheory/videos/favicon.png": "5dcef449791fa27946b3d35ad8803796",
"assets/assets/colortheory/pdfs/favicon.png": "5dcef449791fa27946b3d35ad8803796",
"assets/assets/colortheory/fonts/Silkscreen-Regular.ttf": "fcd900f12e2344da17896f8e5fe55456",
"assets/assets/colortheory/fonts/Silkscreen-Bold.ttf": "aa595a6499f28048bc58b8c6d0157d56",
"assets/assets/colortheory/fonts/favicon.png": "5dcef449791fa27946b3d35ad8803796",
"canvaskit/skwasm.js": "ea559890a088fe28b4ddf70e17e60052",
"canvaskit/skwasm.js.symbols": "e72c79950c8a8483d826a7f0560573a1",
"canvaskit/canvaskit.js.symbols": "bdcd3835edf8586b6d6edfce8749fb77",
"canvaskit/skwasm.wasm": "39dd80367a4e71582d234948adc521c0",
"canvaskit/chromium/canvaskit.js.symbols": "b61b5f4673c9698029fa0a746a9ad581",
"canvaskit/chromium/canvaskit.js": "8191e843020c832c9cf8852a4b909d4c",
"canvaskit/chromium/canvaskit.wasm": "f504de372e31c8031018a9ec0a9ef5f0",
"canvaskit/canvaskit.js": "728b2d477d9b8c14593d4f9b82b484f3",
"canvaskit/canvaskit.wasm": "7a3f4ae7d65fc1de6a6e7ddd3224bc93"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
