{{flutter_js}}
{{flutter_build_config}}

var target = document.getElementById('flutter_app');


_flutter.loader.load({
  onEntrypointLoaded: async function (engineInitializer) {
    const appRunner = await engineInitializer.initializeEngine({
      hostElement: target,
    });
    await appRunner.runApp();

  }
});