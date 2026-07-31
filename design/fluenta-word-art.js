/* Fluenta — визуальные образы слов: тонкие пиктограммы (24×24, stroke 1.6) для попапов и карточек. */
(function () {
  var P = {
    waves: '<path d="M3 7c2.5 2 5.5 2 8 0s5.5-2 8 0"></path><path d="M3 12.5c2.5 2 5.5 2 8 0s5.5-2 8 0"></path><path d="M3 18c2.5 2 5.5 2 8 0s5.5-2 8 0"></path>',
    lighthouse: '<path d="M9.5 22l1-14h3l1 14"></path><path d="M8.5 8h7"></path><path d="M10 8l-.5-4h5L14 8"></path><path d="M12 2v2"></path><path d="M18 5.5l3-1"></path><path d="M18 9l3 1"></path><path d="M6 5.5l-3-1"></path><path d="M6 9l-3 1"></path><path d="M5 22h14"></path>',
    tea: '<path d="M5 9h11v5a4 4 0 0 1-4 4H9a4 4 0 0 1-4-4z"></path><path d="M16 10h2a2 2 0 0 1 0 4h-2"></path><path d="M8 3c0 1.5 1 1.5 1 3"></path><path d="M12 3c0 1.5 1 1.5 1 3"></path>',
    stairs: '<path d="M3 20h4v-4h4v-4h4V8h4"></path><path d="M3 20h18"></path>',
    sun: '<circle cx="12" cy="12" r="4"></circle><path d="M12 2v2"></path><path d="M12 20v2"></path><path d="M4.9 4.9l1.4 1.4"></path><path d="M17.7 17.7l1.4 1.4"></path><path d="M2 12h2"></path><path d="M20 12h2"></path><path d="M4.9 19.1l1.4-1.4"></path><path d="M17.7 6.3l1.4-1.4"></path>',
    moon: '<path d="M21 12.8A9 9 0 1 1 11.2 3a7 7 0 0 0 9.8 9.8z"></path>',
    wind: '<path d="M3 8h9a3 3 0 1 0-3-3"></path><path d="M3 12h13a3 3 0 1 1-3 3"></path><path d="M3 16h5"></path>',
    storm: '<path d="M17 16a4 4 0 0 0 0-8 5.5 5.5 0 0 0-10.4 1.6A4 4 0 0 0 7 16"></path><path d="M13 11l-3 5h4l-3 5"></path>',
    lamp: '<path d="M12 3a6 6 0 0 1 3.7 10.7c-.5.5-.7 1.2-.7 2.3h-6c0-1.1-.2-1.8-.7-2.3A6 6 0 0 1 12 3z"></path><path d="M9 19h6"></path><path d="M10 22h4"></path>',
    lampoff: '<path d="M12 3a6 6 0 0 1 3.7 10.7c-.5.5-.7 1.2-.7 2.3h-6c0-1.1-.2-1.8-.7-2.3A6 6 0 0 1 12 3z"></path><path d="M9 19h6"></path><path d="M10 22h4"></path><path d="M4 4l16 16"></path>',
    lantern: '<rect x="8" y="6" width="8" height="11" rx="2"></rect><path d="M10 3h4"></path><path d="M12 3v3"></path><path d="M12 13.5c1.1 0 1.8-.7 1.8-1.8 0-1.3-1.8-2.7-1.8-2.7s-1.8 1.4-1.8 2.7c0 1.1.7 1.8 1.8 1.8z"></path><path d="M12 17v4"></path><path d="M10 21h4"></path>',
    village: '<path d="M3 11l9-8 9 8"></path><path d="M5 10v10h14V10"></path><path d="M9 20v-6h6v6"></path>',
    wall: '<rect x="3" y="6" width="18" height="12"></rect><path d="M3 12h18"></path><path d="M9 6v6"></path><path d="M15 12v6"></path>',
    person: '<circle cx="12" cy="8" r="4"></circle><path d="M5 21c0-4 3-6 7-6s7 2 7 6"></path>',
    flame: '<path d="M8.5 14.5A2.5 2.5 0 0 0 11 12c0-1.38-.5-2-1-3-1.072-2.143-.224-4.054 2-6 .5 2.5 2 4.9 4 6.5 2 1.6 3 3.5 3 5.5a7 7 0 1 1-14 0c0-1.153.433-2.294 1-3a2.5 2.5 0 0 0 2.5 2.5z"></path>',
    book: '<path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path><path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path>',
    anchor: '<circle cx="12" cy="5" r="3"></circle><path d="M12 8v14"></path><path d="M5 12H2a10 10 0 0 0 20 0h-3"></path>',
    sprout: '<path d="M12 22v-7"></path><path d="M12 15c0-4-3.5-6-8-6 0 4.5 3.5 6 8 6z"></path><path d="M12 15c0-4 3.5-6 8-6 0 4.5-3.5 6-8 6z"></path>',
    snow: '<path d="M12 3v18"></path><path d="M4.5 7.5l15 9"></path><path d="M19.5 7.5l-15 9"></path><path d="M9.5 4.5L12 7l2.5-2.5"></path><path d="M9.5 19.5L12 17l2.5 2.5"></path>'
  };
  window.FluentaWordArt = {
    has: function (n) { return !!P[n]; },
    svg: function (n, size, color) {
      if (!P[n]) return '';
      return '<svg width="' + (size || 24) + '" height="' + (size || 24) + '" viewBox="0 0 24 24" fill="none" stroke="' + (color || '#4F46E5') + '" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">' + P[n] + '</svg>';
    }
  };
})();
