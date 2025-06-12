(function () {
  if ("fonts" in document) {
    if (sessionStorage.fontsLoadedSourceFonts) {
      document.documentElement.className += " fonts-loaded-2";
      return;
    }

    const hasItalics = document.querySelector("em, i");
    const hasCode = document.querySelector("code, pre, kbd, samp, tt, var");
    const hasCodeItalics = document.querySelector(
      "code em, code i, pre em, pre i, kbd em, kbd i, samp em, samp i, tt em, tt i, var em, var i",
    );

    const stage1Promises = [
      "1.5rem 'Source Sans 3 Faux'",
      "1.5rem 'Source Code Pro Faux'",
    ];
    const stage2Promises = ["1.5rem 'Source Sans 3'"];

    if (hasCode) {
      stage2Promises.push("1.5rem 'Source Code Pro'");
    }
    if (hasItalics) {
      stage2Promises.push("italic 1.5rem 'Source Sans 3'");
    }
    if (hasCodeItalics) {
      stage2Promises.push("italic 1.5rem 'Source Code Pro'");
    }

    Promise.all(stage1Promises.map((font) => document.fonts.load(font))).then(
      function () {
        document.documentElement.className += " fonts-loaded-1";

        Promise.all(
          stage2Promises.map((font) => document.fonts.load(font)),
        ).then(function () {
          document.documentElement.className += " fonts-loaded-2";
          sessionStorage.fontsLoadedSourceFonts = true;
        });
      },
    );
  }
})();
