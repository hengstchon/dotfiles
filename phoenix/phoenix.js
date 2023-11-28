const modKey = "option";

const switchApp = (key, appName) => {
  Key.on(key, [modKey], () => {
    const app = App.get(appName);
    if (!app) {
      App.launch(appName, { focus: true });
    } else {
      if (app.isActive()) {
        app.hide();
      } else {
        app.focus();
      }
    }
  });
};

const getAppName = () => {
  Key.on('d', ['option'], () => {
    const app = App.focused()
    console.log('appName: ', app.name())
  })
}
// getAppName()

const resize = (key) => {
  const win = Window.focused();
  var frame = win.screen().flippedFrame();
  Key.on(key, [modKey], () => {
    win.setTopLeft({ x: 0, y: 0 });
  });
};

switchApp("1", "Brave Browser");
switchApp("2", "Alacritty");
switchApp("3", "Obsidian");
switchApp("4", "zathura");
switchApp("e", "Dictionary");
switchApp("d", "德语助手");

// resize('right')
