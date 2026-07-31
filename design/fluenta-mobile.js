/* Fluenta — shared touch helpers: bottom sheet + long-press selection. Pointer events, no mouse-only APIs. */
(function () {
  var MQ = window.matchMedia('(max-width: 639px)');

  /* Bottom-sheet controller for a .fl-sheet element (mobile only).
     states: 'closed' | 'half' (~60% visible) | 'full' */
  function sheet(el, opts) {
    opts = opts || {};
    var half = opts.half != null ? opts.half : 0.40; /* fraction hidden at half state */
    var grip = opts.grip || el.querySelector('.fl-grip');
    var backdrop = opts.backdrop || null;
    var state = 'closed', dragging = false;
    function isM() { return MQ.matches; }
    function yFor(st) { return st === 'closed' ? 102 : st === 'half' ? half * 100 : 0; }
    function apply(anim) {
      if (!isM()) return;
      el.style.transition = anim === false ? 'none' : 'transform .3s cubic-bezier(.22,.61,.36,1)';
      el.style.transform = 'translateY(' + yFor(state) + '%)';
      if (backdrop) backdrop.classList.toggle('on', state !== 'closed');
    }
    function set(st, anim) {
      var was = state;
      state = st;
      apply(anim);
      if (st === 'closed' && was !== 'closed' && opts.onClose) opts.onClose();
    }
    var startY = 0, startPct = 0, lastY = 0, lastT = 0, vel = 0;
    function curPct() {
      var m = /translateY\((-?[\d.]+)%\)/.exec(el.style.transform || '');
      return m ? parseFloat(m[1]) : yFor(state);
    }
    function onDown(e) {
      if (!isM()) return;
      dragging = true; vel = 0;
      startY = lastY = e.clientY; lastT = performance.now();
      startPct = curPct();
      el.style.transition = 'none';
      try { grip.setPointerCapture(e.pointerId); } catch (err) {}
      e.preventDefault();
    }
    function onMove(e) {
      if (!dragging) return;
      var h = el.getBoundingClientRect().height || 1;
      var now = performance.now();
      vel = (e.clientY - lastY) / Math.max(1, now - lastT);
      lastY = e.clientY; lastT = now;
      var pct = Math.min(102, Math.max(0, startPct + (e.clientY - startY) / h * 100));
      el.style.transform = 'translateY(' + pct + '%)';
    }
    function onUp() {
      if (!dragging) return;
      dragging = false;
      var pct = curPct(), hp = half * 100, st;
      if (vel > 0.55) st = pct > hp ? 'closed' : 'half';
      else if (vel < -0.55) st = pct > hp ? 'half' : 'full';
      else st = pct < hp / 2 ? 'full' : (pct < (hp + 102) / 2 ? 'half' : 'closed');
      set(st);
    }
    if (grip) {
      grip.addEventListener('pointerdown', onDown);
      grip.addEventListener('pointermove', onMove);
      grip.addEventListener('pointerup', onUp);
      grip.addEventListener('pointercancel', onUp);
    }
    if (backdrop) backdrop.addEventListener('click', function () { set('closed'); });
    MQ.addEventListener('change', function () {
      if (isM()) { state = 'closed'; apply(false); }
      else {
        el.style.transform = ''; el.style.transition = '';
        if (backdrop) backdrop.classList.remove('on');
        state = 'closed';
      }
      if (opts.onModeChange) opts.onModeChange(isM());
    });
    if (isM()) apply(false);
    return {
      open: function (st) { set(st || 'half'); },
      close: function () { set('closed'); },
      expand: function () { set('full'); },
      state: function () { return state; },
      isMobile: isM
    };
  }

  /* Long-press (touch) then drag over items → custom selection. */
  function longPress(container, opts) {
    var delay = opts.delay || 430, sel = opts.itemSelector;
    var timer = null, active = false, startX = 0, startY = 0, pid = null, anchor = null;
    function itemAt(x, y) {
      var el = document.elementFromPoint(x, y);
      return el && el.closest ? el.closest(sel) : null;
    }
    function cancelTimer() { clearTimeout(timer); timer = null; }
    container.addEventListener('pointerdown', function (e) {
      if (e.pointerType !== 'touch') return;
      var it = e.target.closest ? e.target.closest(sel) : null;
      if (!it) return;
      startX = e.clientX; startY = e.clientY; pid = e.pointerId; anchor = it;
      cancelTimer();
      timer = setTimeout(function () {
        timer = null; active = true;
        if (navigator.vibrate) { try { navigator.vibrate(10); } catch (err) {} }
        opts.onStart && opts.onStart(anchor);
      }, delay);
    }, { passive: true });
    container.addEventListener('pointermove', function (e) {
      if (e.pointerId !== pid) return;
      if (!active) {
        if (timer && (Math.abs(e.clientX - startX) > 8 || Math.abs(e.clientY - startY) > 8)) cancelTimer();
        return;
      }
      var it = itemAt(e.clientX, e.clientY);
      if (it) opts.onMove && opts.onMove(it);
    }, { passive: true });
    container.addEventListener('touchmove', function (e) { if (active) e.preventDefault(); }, { passive: false });
    container.addEventListener('contextmenu', function (e) { if (active || timer) e.preventDefault(); });
    function end(e) {
      if (pid != null && e && e.pointerId !== pid) return;
      cancelTimer();
      pid = null;
      if (active) { active = false; opts.onEnd && opts.onEnd(); }
    }
    container.addEventListener('pointerup', end);
    container.addEventListener('pointercancel', end);
    return {
      isActive: function () { return active; },
      cancel: function () { cancelTimer(); active = false; }
    };
  }

  window.FluentaMobile = {
    sheet: sheet,
    longPress: longPress,
    mq: MQ,
    isMobile: function () { return MQ.matches; },
    isCoarse: function () { return window.matchMedia('(pointer: coarse)').matches; }
  };
})();
