function addCustomFont(send, fontName) {
  const link = document.createElement("link");
  link.rel = "stylesheet";
  link.href = `https://fonts.googleapis.com/css?family=${fontName}`;
  link.onload = (_) => {
    console.log("Loaded font:", fontName);
    send({
      tag: "loadGoogleFont.loaded",
      value: fontName,
    });
  };
  link.onerror = (_) => {
    send({
      tag: "loadGoogleFont.error",
      value: fontName,
    });
  }
  document.head.appendChild(link);
}

function start(send, subscribe) {
  subscribe((message) => {
    console.log("Received message: ", message);

    if (message.tag == "addCustomFont") {
      addCustomFont(send, message.value);
    } else {
      console.log("Ignored message: ", message);
    }
  });
}
