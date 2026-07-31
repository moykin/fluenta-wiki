/* Fluenta — произношение слов.
   Web Speech API; если синтез недоступен (или заблокирован), say() всё равно
   отыгрывает состояние «звучит» по длине слова, чтобы прототип не ломался. */
(function (W) {
  if (W.FluentaSpeak) return;
  var S = W.speechSynthesis;
  var UT = W.SpeechSynthesisUtterance;
  var supported = !!(S && UT);
  var seq = 0, timer = null, activeEnd = null;

  if (supported) {
    try { S.getVoices(); S.onvoiceschanged = function () { S.getVoices(); }; } catch (e) {}
  }

  function voiceFor(lang) {
    if (!supported) return null;
    var vs = [];
    try { vs = S.getVoices() || []; } catch (e) {}
    if (!vs.length) return null;
    var want = (lang || 'en-GB').toLowerCase().replace('_', '-');
    var base = want.slice(0, 2);
    var norm = function (v) { return (v.lang || '').toLowerCase().replace('_', '-'); };
    var pool = vs.filter(function (v) { return norm(v) === want; });
    if (!pool.length) pool = vs.filter(function (v) { return norm(v).slice(0, 2) === base; });
    if (!pool.length) return null;
    var nice = pool.filter(function (v) { return /google|natural|premium|enhanced|samantha|daniel|serena|karen/i.test(v.name || ''); });
    return nice[0] || pool[0];
  }

  function finish() {
    var f = activeEnd;
    activeEnd = null;
    if (timer) { clearTimeout(timer); timer = null; }
    if (f) { try { f(); } catch (e) {} }
  }

  function stop() {
    seq++;
    if (supported) { try { S.cancel(); } catch (e) {} }
    finish();
  }

  function say(text, opts) {
    text = String(text == null ? '' : text).trim();
    opts = opts || {};
    if (!text) return false;
    stop();
    var id = seq;
    var rate = opts.rate == null ? 0.95 : opts.rate;
    var lang = opts.lang || 'en-GB';
    var guess = Math.min(5000, 420 + text.length * 105 / Math.max(0.4, rate));
    activeEnd = function () { if (opts.onEnd) opts.onEnd(); };
    if (opts.onStart) opts.onStart();
    if (!supported) { timer = setTimeout(function () { if (id === seq) finish(); }, guess); return 'demo'; }
    var u = new UT(text);
    var v = voiceFor(lang);
    u.lang = v && v.lang ? v.lang : lang;
    if (v) u.voice = v;
    u.rate = rate;
    u.pitch = 1;
    var began = false;
    u.onstart = function () { began = true; };
    u.onend = function () { if (id === seq) finish(); };
    /* синтез заблокирован (нет жеста, песочница) — доигрываем состояние по таймеру */
    u.onerror = function () {
      if (id !== seq) return;
      if (began) { finish(); return; }
      if (timer) clearTimeout(timer);
      timer = setTimeout(function () { if (id === seq) finish(); }, guess);
    };
    timer = setTimeout(function () { if (id === seq) finish(); }, guess + 2400);
    try { S.speak(u); } catch (e) { finish(); return 'demo'; }
    return 'speech';
  }

  W.FluentaSpeak = { supported: supported, say: say, stop: stop, voiceFor: voiceFor };
})(window);
