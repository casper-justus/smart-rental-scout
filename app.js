(function() {
  'use strict';

  // ============= PAGE REGISTRY =============
  var PAGES = {
    'discovery': '01-discovery-commute-setup.html',
    'commute-hub': '02-commute-hub-settings.html',
    'app-step1': '03-application-portal-step1.html',
    'listing-details': '04-listing-details-commute-vr.html',
    'profile': '05-user-profile.html',
    'submission-success': '06-refined-submission-success.html',
    'compare': '07-compare-properties.html',
    'virtual-tour': '08-virtual-tour-list-view-navigation.html',
    'submission-success-old': '09-submission-success.html',
    'app-step2': '10-application-portal-step2.html',
    'app-step3': '11-application-portal-step3.html',
    'app-step4': '12-application-portal-step4-review.html',
    'home': '15-home-page.html',
    'home-synced': '13-tenantmatch-synced-production-ui.html',
    'saved-searches': '14-saved-searches.html',
    'map-search': '16-map-search.html'
  };

  var CURRENT_FILE = window.location.pathname.split('/').pop();

  // ============= NAV BY KEYWORD =============
  function getPageKey(el) {
    var text = (el.textContent || '').toLowerCase().trim();
    var icon = (el.querySelector('.material-symbols-outlined') || {}).textContent || '';
    var href = (el.getAttribute('href') || '').toLowerCase();
    var label = text + '|' + icon.toLowerCase();

    if (href === '#') return null;

    if (label.includes('home') || icon === 'home') return 'home';
    if (label.includes('search') || icon === 'search') return 'map-search';
    if (label.includes('saved') || icon === 'favorite' || icon === 'bookmark') return 'saved-searches';
    if (label.includes('dashboard')) return 'home';
    if (label.includes('profile') || icon === 'person' || icon === 'account_circle') return 'profile';
    if (label.includes('explore')) return 'map-search';
    if (label.includes('compare') || icon === 'compare_arrows') return 'compare';
    if (label.includes('commute') || icon === 'directions_transit') return 'commute-hub';
    if (label.includes('virtual') || icon === 'view_in_ar') return 'virtual-tour';
    if (label.includes('saved search')) return 'saved-searches';
    if (icon === 'dashboard') return 'home';
    if (icon === 'handshake') return 'home';
    return null;
  }

  function navigate(key) {
    if (PAGES[key] && PAGES[key] !== CURRENT_FILE) {
      window.location.href = PAGES[key];
    }
  }

  // ============= TOAST =============
  function showToast(msg) {
    var existing = document.querySelector('.tm-toast');
    if (existing) existing.remove();
    var t = document.createElement('div');
    t.className = 'tm-toast';
    t.textContent = msg;
    Object.assign(t.style, {
      position:'fixed', bottom:'100px', left:'50%', transform:'translateX(-50%)',
      background:'#031636', color:'#fff', padding:'12px 24px', borderRadius:'12px',
      fontFamily:'Inter, sans-serif', fontSize:'14px', zIndex:'9999',
      boxShadow:'0 8px 24px rgba(0,0,0,0.2)', opacity:'0', transition:'opacity 0.3s'
    });
    document.body.appendChild(t);
    requestAnimationFrame(function(){ t.style.opacity = '1'; });
    setTimeout(function(){
      t.style.opacity = '0';
      setTimeout(function(){ t.remove(); }, 400);
    }, 2000);
  }

  function showAlert(title, msg) {
    var overlay = document.createElement('div');
    overlay.className = 'tm-alert-overlay';
    Object.assign(overlay.style, {
      position:'fixed', inset:'0', background:'rgba(0,0,0,0.4)', display:'flex',
      alignItems:'center', justifyContent:'center', zIndex:'99999',
      fontFamily:'Inter, sans-serif'
    });
    var box = document.createElement('div');
    Object.assign(box.style, {
      background:'#fff', borderRadius:'16px', padding:'28px 24px 20px',
      maxWidth:'340px', width:'90%', boxShadow:'0 16px 48px rgba(0,0,0,0.2)',
      textAlign:'center'
    });
    box.innerHTML = '<div style="font-size:20px;font-weight:600;color:#031636;margin-bottom:8px">' +
      title + '</div><div style="font-size:14px;color:#44474e;margin-bottom:20px;line-height:1.5">' +
      msg + '</div><button class="tm-alert-ok" style="background:#031636;color:#fff;border:none;padding:10px 32px;border-radius:10px;font-size:15px;font-weight:600;cursor:pointer">OK</button>';
    overlay.appendChild(box);
    document.body.appendChild(overlay);
    box.querySelector('.tm-alert-ok').addEventListener('click', function(){ overlay.remove(); });
    overlay.addEventListener('click', function(e){ if(e.target === overlay) overlay.remove(); });
  }

  // ============= EVENT DELEGATION =============
  document.addEventListener('click', function(e) {
    var target = e.target.closest('button, a, [role="button"], .cursor-pointer, [onclick]');
    if (!target) return;
    if (target.closest('.tm-alert-overlay')) return;

    // === NAVIGATION ===
    var navKey = target.getAttribute('data-nav');
    if (navKey) { e.preventDefault(); navigate(navKey); return; }

    // Back buttons
    if (target.closest('[data-icon="arrow_back"]') || target.closest('[data-icon="close"]') ||
        (target.querySelector('.material-symbols-outlined') &&
         (target.querySelector('.material-symbols-outlined').textContent === 'arrow_back' ||
          target.querySelector('.material-symbols-outlined').textContent === 'close'))) {
      e.preventDefault();
      var from = getSourcePage();
      if (from) { navigate(from); return; }
      if (window.history.length > 1) { window.history.back(); }
      else { navigate('home'); }
      return;
    }

    // Skip links
    if (target.tagName === 'A' && target.getAttribute('href') !== '#' && target.getAttribute('href')) return;

    // === NAV BAR / SIDE NAV ===
    var navItem = target.closest('[class*="flex-col"][class*="items-center"] a, nav a, nav button, [class*="flex-col"][class*="items-center"] button, nav [class*="flex-col"][class*="items-center"]');
    var pageKey = null;

    if (navItem && !navItem.closest('[data-nav]')) {
      pageKey = getPageKey(navItem);
      if (pageKey) { e.preventDefault(); navigate(pageKey); return; }
    }

    // === INDIVIDUAL BUTTON ACTIONS ===
    var btnText = (target.textContent || '').toLowerCase().trim();
    var btnIcon = (target.querySelector('.material-symbols-outlined') || {}).textContent || '';

    // === NAVIGATION MATCHES ===
    if (btnText.includes('start hunting') || btnText.includes('get started')) {
      e.preventDefault(); navigate('home'); return;
    }
    if (btnText.includes('apply now')) {
      e.preventDefault(); navigate('app-step1'); return;
    }
    if (btnText.includes('apply for')) {
      e.preventDefault(); navigate('app-step1'); return;
    }
      if (btnText.includes('schedule tour') || btnText === 'tour') {
        e.preventDefault(); showAlert('Tour Scheduled!', 'Your tour request has been received. The property manager will confirm your appointment within 24 hours.'); return;
      }
    if (btnText.includes('continue') && btnText.includes('document')) {
      e.preventDefault(); saveFormData(); navigate('app-step2'); return;
    }
    if (btnText.includes('save') && btnText.includes('continue')) {
      e.preventDefault(); saveFormData();
      var step = getCurrentStep();
      if (step === 2) navigate('app-step3');
      else if (step === 3) navigate('app-step4');
      return;
    }
    if (btnText.includes('back') && btnText.includes('reference')) {
      e.preventDefault(); navigate('app-step3'); return;
    }
    if (btnText === 'back') {
      e.preventDefault();
      if (window.history.length > 1) window.history.back();
      else navigate('home');
      return;
    }
    if (btnText.includes('submit application') || target.id === 'submitBtn') {
      e.preventDefault();
      var cb = document.getElementById('terms');
      if (cb && !cb.checked) { showToast('Please agree to the terms first.'); return; }
      saveFormData();
      showAlert('Application Submitted!', 'Your application has been successfully submitted. The landlord will review your profile within 24-48 hours.');
      setTimeout(function(){ navigate('submission-success'); }, 500);
      return;
    }
    if (btnText.includes('view application status')) {
      e.preventDefault(); navigate('home'); return;
    }
    if (btnText.includes('return to dashboard')) {
      e.preventDefault(); navigate('home'); return;
    }
    if (btnText.includes('exit tour')) {
      e.preventDefault(); navigate('listing-details'); return;
    }

    // Sidebar nav items
    var sidebarLink = target.closest('a[href="#"]');
    if (sidebarLink) {
      e.preventDefault();
      var sk = getPageKey(sidebarLink);
      if (sk) navigate(sk);
      return;
    }

    // ============ CHIPS & TOGGLES ============
    if (target.getAttribute('role') === 'togglebutton' || target.closest('[role="togglebutton"]')) {
      var chip = target.closest('[role="togglebutton"]') || target;
      chip.setAttribute('aria-pressed', chip.getAttribute('aria-pressed') === 'true' ? 'false' : 'true');
      chip.classList.toggle('chip-active');
      chip.classList.toggle('bg-surface-container');
      return;
    }

    if (target.closest('.perk-chip')) {
      var pc = target.closest('.perk-chip');
      pc.classList.toggle('chip-active');
      pc.classList.toggle('bg-surface-container');
      return;
    }

    // ============ DROPDOWNS ============
    var dropdownBtn = target.closest('.dropdown > button, [class*="dropdown"] > button');
    if (dropdownBtn && dropdownBtn.closest('.dropdown')) {
      var dd = dropdownBtn.closest('.dropdown');
      var menu = dd.querySelector('.dropdown-menu');
      if (menu) {
        var isOpen = !menu.classList.contains('opacity-0');
        document.querySelectorAll('.dropdown-menu').forEach(function(m){
          m.classList.add('opacity-0', 'pointer-events-none');
        });
        if (!isOpen) {
          menu.classList.remove('opacity-0', 'pointer-events-none');
        }
      }
      return;
    }

    // ============ VIEW BUTTONS ============
    if (btnText === 'view') {
      e.preventDefault(); navigate('map-search'); return;
    }

    // ============ HEART / SAVE ============
    if (btnIcon === 'favorite' || btnIcon === 'favorite_border') {
      e.preventDefault();
      e.stopPropagation();
      var heart = target.closest('button');
      if (heart) {
        var icon = heart.querySelector('.material-symbols-outlined');
        if (icon) {
          var isFilled = icon.textContent === 'favorite';
          icon.textContent = isFilled ? 'favorite_border' : 'favorite';
          icon.style.setProperty('font-variation-settings', isFilled ? "'FILL' 0" : "'FILL' 1");
          saveFavorites();
        }
      }
      return;
    }

    // ============ SHARE ============
    if (btnIcon === 'share') {
      e.preventDefault();
      if (navigator.share) {
        navigator.share({ title: document.title, url: window.location.href });
      } else {
        navigator.clipboard.writeText(window.location.href).then(function(){
          showToast('Link copied to clipboard!');
        });
      }
      return;
    }

    // ============ EDIT / DELETE ============
    if (btnIcon === 'edit' && !target.closest('[class*="rounded-full"]')) {
      e.preventDefault();
      var section = target.closest('section, [class*="rounded-xl"], [class*="p-stack"]');
      if (section) {
        section.querySelectorAll('input, select, textarea').forEach(function(el){ el.readOnly = false; el.disabled = false; el.classList.remove('opacity-50'); });
        var note = section.querySelector('[class*="font-label-caps"]');
        if (note && !note.textContent.includes('EDITING')) note.textContent += ' — EDITING';
        showAlert('Edit Mode', 'Form fields in this section are now editable.');
      }
      return;
    }
    if (btnIcon === 'delete') {
      e.preventDefault();
      var card = target.closest('[class*="rounded-xl"], [class*="p-stack"]');
      if (card) { card.style.transition = 'all 0.3s'; card.style.opacity = '0'; card.style.transform = 'scale(0.95)'; setTimeout(function(){ card.remove(); saveFavorites(); }, 300); }
      return;
    }
    if (btnIcon === 'more_vert') {
      e.preventDefault(); showAlert('Options', 'Edit, Share, Delete, and Report options would appear here.'); return;
    }

    // ============ ADD BUTTONS ============
    if (btnText.includes('add new destination') || btnText.includes('add a destination')) {
      e.preventDefault();
      var input = document.querySelector('[placeholder*="Enter a destination"], [placeholder*="Add a destination"]');
      if (input && input.value.trim()) {
        var tag = document.createElement('button');
        tag.className = 'px-3 py-1.5 bg-primary text-on-primary rounded-full font-body-md text-body-md flex items-center gap-1 hover:opacity-80 transition-colors';
        tag.innerHTML = input.value.trim() + '<span class="material-symbols-outlined text-[14px] ml-1">close</span>';
        tag.onclick = function(){ this.remove(); };
        var container = input.closest('section, [class*="flex-col"]').querySelector('.flex.flex-wrap.gap-2');
        if (container) { container.appendChild(tag); input.value = ''; }
      } else {
        showAlert('Missing Info', 'Please enter a destination name first.');
      }
      return;
    }
    if (btnText.includes('add another document') || btnIcon === 'add' && target.closest('[class*="border-dashed"]')) {
      e.preventDefault();
      var fileInput = target.closest('[class*="border-dashed"]') ? target.closest('[class*="border-dashed"]').querySelector('input[type="file"]') : null;
      if (fileInput) fileInput.click();
      return;
    }
    if (btnText.includes('add reference')) {
      e.preventDefault();
      var container = document.getElementById('references-container');
      if (container) {
        var clone = container.querySelector('[class*="rounded-xl"]');
        if (clone) {
          var newRef = clone.cloneNode(true);
          newRef.querySelectorAll('input').forEach(function(i){ i.value = ''; });
          container.appendChild(newRef);
          showToast('Reference added');
        }
      }
      return;
    }
    if (btnText.includes('add to compare') || btnIcon === 'add' && target.closest('[class*="border-dashed"]')) {
      e.preventDefault(); navigate('compare'); return;
    }
    if (target.closest('[class*="w-12"][class*="h-12"][class*="border-dashed"]')) {
      e.preventDefault(); navigate('compare'); return;
    }

    // ============ PROPERTY CARDS ============
    if (target.closest('article, [class*="rounded-xl"]')) {
      var card = target.closest('article, [class*="rounded-xl"]');
      if (card && !target.closest('button') && !target.closest('a')) {
        var isPropertyCard = card.querySelector('[class*="headline-md"]') || card.querySelector('[data-icon="bed"]');
        if (isPropertyCard) {
          e.preventDefault(); navigate('listing-details'); return;
        }
      }
    }

    // ============ QUICK ACTION CARDS ============
    if (target.closest('[class*="min-w-\\[160px\\]"]') || target.closest('[class*="quick"]')) {
      var qc = target.closest('[class*="min-w-\\[160px\\]"]') || target.closest('.cursor-pointer');
      if (qc && qc.textContent.toLowerCase().includes('commute')) { navigate('commute-hub'); return; }
      if (qc && (qc.textContent.toLowerCase().includes('saved') || qc.textContent.toLowerCase().includes('bookmark'))) { navigate('saved-searches'); return; }
      if (qc && (qc.textContent.toLowerCase().includes('virtual') || qc.textContent.toLowerCase().includes('tour'))) { navigate('virtual-tour'); return; }
    }

    // ============ MAP PINS ============
    if (target.closest('[class*="absolute"]') && target.textContent.includes('$')) {
      var pin = target.closest('button');
      if (pin && pin.closest('[class*="pointer-events-auto"]')) {
        e.preventDefault(); navigate('listing-details'); return;
      }
    }

    // ============ SEE ALL ============
    if (btnText === 'see all' || (target.closest('a') && target.closest('a').textContent.trim().toLowerCase() === 'see all')) {
      e.preventDefault(); navigate('map-search'); return;
    }

    // ============ FILTERS BUTTON ============
    if (btnIcon === 'tune' || btnText.includes('filter')) {
      e.preventDefault(); showAlert('Filters', 'Price Range: $500 – $5,000 · Bedrooms: 1–4 · Property Type: Apartment, House, Condo · Amenities: Parking, Gym, Laundry, Pets'); return;
    }

    // ============ NOTIFICATIONS ============
    if (btnIcon === 'notifications') {
      e.preventDefault(); showToast('No new notifications'); return;
    }

    // ============ HELP ============
    if (btnIcon === 'help') {
      e.preventDefault(); showAlert('Help', 'This is a demo of the TenantMatch application. All features shown are for demonstration purposes.'); return;
    }

    // ============ MENU / MORE ============
    if (btnIcon === 'menu') {
      e.preventDefault(); showAlert('Navigation', 'Home · Search · Saved · Dashboard · Profile · Settings'); return;
    }

    // ============ SAVE CHANGES (PROFILE) ============
    if (btnText.includes('save changes')) {
      e.preventDefault(); saveFormData(); showToast('Profile saved!'); return;
    }

    // ============ CHECK (PROFILE SAVE) ============
    if (btnIcon === 'check') {
      e.preventDefault(); saveFormData(); showToast('Profile updated!'); return;
    }

    // ============ EDIT (REVIEW SECTION) ============
    if (btnText === 'edit' && target.closest('section')) {
      e.preventDefault();
      var sectionTitle = (target.closest('section').querySelector('h2') || {}).textContent || '';
      if (sectionTitle.toLowerCase().includes('personal')) { navigate('app-step1'); return; }
      if (sectionTitle.toLowerCase().includes('document')) { navigate('app-step2'); return; }
      if (sectionTitle.toLowerCase().includes('reference')) { navigate('app-step3'); return; }
      navigate('app-step1'); return;
    }

    // ============ FULLSCREEN ============
    if (btnIcon === 'fullscreen') {
      e.preventDefault();
      if (!document.fullscreenElement) document.documentElement.requestFullscreen().catch(function(){});
      else document.exitFullscreen();
      return;
    }

    // ============ MY LOCATION ============
    if (btnIcon === 'my_location') {
      e.preventDefault(); showAlert('Finding Location', 'Using GPS to determine your current location…'); setTimeout(function(){ showAlert('Location Found', 'You are in Downtown Seattle. Showing nearby listings.'); }, 1500); return;
    }

    // ============ MAP ZOOM ============
    if (btnIcon === 'add' && target.closest('[class*="flex-col"]') && target.closest('[class*="rounded-lg"]')) {
      e.preventDefault();
      var map = document.querySelector('[class*="bg-surface-container-high"] img, .flex-1 img');
      if (map) { var s = parseFloat(map.style.transform.replace('scale(','') || '1'); map.style.transform = 'scale(' + Math.min(s + 0.2, 3) + ')'; map.style.transition = 'transform 0.3s'; }
      return;
    }
    if (btnIcon === 'remove' && target.closest('[class*="flex-col"]') && target.closest('[class*="rounded-lg"]')) {
      e.preventDefault();
      var map = document.querySelector('[class*="bg-surface-container-high"] img, .flex-1 img');
      if (map) { var s = parseFloat(map.style.transform.replace('scale(','') || '1'); map.style.transform = 'scale(' + Math.max(s - 0.2, 0.5) + ')'; map.style.transition = 'transform 0.3s'; }
      return;
    }

    // ============ FLOATING ACTION BUTTON ============
    if (target.closest('[class*="fixed"][class*="bottom-"][class*="right-"]') && btnIcon === 'add') {
      e.preventDefault(); showAlert('New Saved Search', 'Name your search criteria:\n• Location: Downtown\n• Max Price: $3,000\n• Beds: 2+\n• Amenities: Gym, Parking\n\nSave this search to get notified of new listings.'); return;
    }

    // ============ VIRTUAL TOUR HOTSPOTS ============
    if (target.closest('[class*="hotspot-pulse"]') || target.closest('[aria-label*="View"]') && target.closest('.pointer-events-auto')) {
      if (target.closest('[aria-label*="View Kitchen"]') || target.textContent.includes('Kitchen')) {
        e.preventDefault(); showAlert('Kitchen Tour', 'This would transition to a 360 view of the kitchen with detailed material information.'); return;
      }
      if (target.closest('[aria-label*="Master Bedroom"]') || target.textContent.includes('Master Bedroom') || target.textContent.includes('Bedroom')) {
        e.preventDefault(); showAlert('Master Bedroom', 'This would transition to a 360 view of the master bedroom with walk-in closet details.'); return;
      }
    }

    // ============ VIRTUAL TOUR LIST ITEMS ============
    if (target.closest('#listViewPanel') || target.closest('#listViewModalWrapper')) {
      var li = target.closest('button');
      if (li && li.querySelector('.material-symbols-outlined')) {
        e.preventDefault();
        var room = (li.querySelector('span:not(.material-symbols-outlined)') || {}).textContent || '';
        showAlert('Navigate to ' + room, 'This would transition the virtual tour to the ' + room + ' view.');
        toggleListView();
        return;
      }
    }

    // ============ MINI-MAP ============
    if (target.closest('[class*="w-32"][class*="h-32"]') || target.closest('[aria-label="Floor plan mini-map"]')) {
      e.preventDefault(); showAlert('Floor Plan', 'This 1,150 sqft unit has:\n• Open concept living/dining\n• 2 bedrooms with walk-in closets\n• 2 full bathrooms\n• In-unit washer/dryer\n• Balcony with city views\n\nClick on rooms to explore.'); return;
    }

    // ============ COMMUTE INSIGHT CARD ============
    if (target.closest('[class*="bg-surface-container-low"][class*="rounded-lg"]') && target.closest('.lg\\:col-span-2')) {
      return;
    }

    // ============ MARKET INSIGHTS CARDS ============
    if (target.closest('[class*="bg-white"][class*="border-l-2"]') || target.closest('[class*="inventory"]')) {
      e.preventDefault(); showAlert('Market Insight', 'This is a market intelligence feature showing real-time rental market data and trends.'); return;
    }

    // === Profile edit button ===
    if (target.closest('[class*="rounded-full"]') && btnIcon === 'edit' && target.closest('.relative') && target.closest('.items-center')) {
      e.preventDefault();
      var fi = document.createElement('input'); fi.type = 'file'; fi.accept = 'image/*';
      fi.onchange = function(){ if (fi.files[0]) { var img = target.closest('.relative, [class*="flex"]').querySelector('img'); if (img) { var r = new FileReader(); r.onload = function(e){ img.src = e.target.result; }; r.readAsDataURL(fi.files[0]); } } };
      fi.click();
      return;
    }

    // TopAppBar notification on page 10
    if (target.closest('header') && btnIcon === 'notifications') {
      e.preventDefault(); showToast('No new notifications'); return;
    }

  }); // end click delegation

  // ============= TOGGLE SWITCHES =============
  document.addEventListener('change', function(e) {
    var t = e.target;

    // Toggle switches
    if (t.type === 'checkbox' && t.closest('.relative') && t.closest('[class*="w-12"]')) {
      var label = t.closest('.flex.items-center.justify-between');
      if (label) {
        var name = (label.querySelector('h4, span, label') || {}).textContent || 'Setting';
        sessionStorage.setItem('tm-toggle-' + name.trim(), t.checked ? '1' : '0');
      }
      return;
    }

    // Background auth toggle
    if (t.id === 'auth-toggle') {
      sessionStorage.setItem('tm-auth-authorized', t.checked ? '1' : '0');
      saveFormData();
      return;
    }

    // Checkbox terms
    if (t.id === 'terms') {
      var btn = document.getElementById('submitBtn');
      if (btn) btn.disabled = !t.checked;
      return;
    }

    // Select changes
    if (t.tagName === 'SELECT') {
      saveFormData();
      return;
    }

    // File input
    if (t.type === 'file') {
      if (t.files.length > 0) {
        var fn = t.files[0].name;
        var dz = t.closest('[class*="border-dashed"]');
        if (dz) {
          var ic = dz.querySelector('.material-symbols-outlined');
          if (ic) { ic.textContent = 'check_circle'; ic.style.color = '#006b5f'; }
          var spans = dz.querySelectorAll('span');
          if (spans.length >= 2) { spans[0].textContent = fn; spans[0].style.color = '#006b5f'; spans[spans.length-1].textContent = 'Click to replace'; }
        }
      }
      return;
    }

    // Range sliders
    if (t.type === 'range') {
      var parent = t.closest('.p-4, [class*="p-stack"]');
      if (parent) {
        var display = parent.querySelector('[class*="font-bold"]');
        if (display) {
          display.textContent = '$1,500 - $' + parseInt(t.value).toLocaleString();
        }
      }
      var priceLabel = t.closest('.space-y-3');
      if (priceLabel) {
        var vals = priceLabel.querySelectorAll('.text-xs span');
        if (vals.length >= 2) {
          vals[1].textContent = '$' + parseInt(t.value).toLocaleString();
        }
      }
      return;
    }
  });

  // ============= FORM HELPERS =============
  function getCurrentStep() {
    var body = document.body.textContent;
    if (body.includes('Step 2 of 4')) return 2;
    if (body.includes('Step 3 of 4') || body.includes('75% Complete')) return 3;
    if (body.includes('STEP 4 OF 4') || body.includes('Step 4 of 4')) return 4;
    return 1;
  }

  function saveFormData() {
    var data = {};
    document.querySelectorAll('input:not([type="file"]):not([type="checkbox"]):not([type="range"]):not([type="radio"]):not([type="hidden"]), select, textarea').forEach(function(el) {
      if (el.id || el.name) {
        data[el.id || el.name] = el.value;
      }
    });
    sessionStorage.setItem('tmFormData', JSON.stringify(data));
  }

  // ============= SOURCE PAGE DETECTION =============
  function getSourcePage() {
    var body = document.body.textContent.toLowerCase();
    if (CURRENT_FILE.includes('02-commute')) return 'home';
    if (CURRENT_FILE.includes('03-app')) return 'listing-details';
    if (CURRENT_FILE.includes('04-listing')) return 'map-search';
    if (CURRENT_FILE.includes('05-user')) return 'home';
    if (CURRENT_FILE.includes('06-refined')) return 'home';
    if (CURRENT_FILE.includes('07-compare')) return 'home';
    if (CURRENT_FILE.includes('08-virtual')) return 'listing-details';
    if (CURRENT_FILE.includes('09-submission')) return 'home';
    if (CURRENT_FILE.includes('10-app')) return 'app-step1';
    if (CURRENT_FILE.includes('11-app')) return 'app-step2';
    if (CURRENT_FILE.includes('12-app')) return 'app-step3';
    if (CURRENT_FILE.includes('13-tenantmatch') || CURRENT_FILE.includes('15-home')) return null;
    if (CURRENT_FILE.includes('14-saved')) return 'home';
    if (CURRENT_FILE.includes('16-map')) return 'home';
    return null;
  }

  // ============= VIRTUAL TOUR FUNCTIONS =============
  window.toggleInfoPanel = function() {
    var panel = document.getElementById('infoPanel');
    if (!panel) return;
    var isHidden = panel.classList.contains('hidden');
    panel.classList.remove('hidden');
    panel.style.display = 'block';
    requestAnimationFrame(function(){
      if (isHidden) {
        panel.classList.remove('scale-95', 'opacity-0');
        panel.classList.add('scale-100', 'opacity-100');
      } else {
        panel.classList.remove('scale-100', 'opacity-100');
        panel.classList.add('scale-95', 'opacity-0');
        setTimeout(function(){ panel.classList.add('hidden'); }, 300);
      }
    });
  };

  window.toggleListView = function() {
    var wrapper = document.getElementById('listViewModalWrapper');
    var panel = document.getElementById('listViewPanel');
    if (!wrapper || !panel) return;
    var isHidden = wrapper.classList.contains('hidden');
    if (isHidden) {
      wrapper.classList.remove('hidden');
      wrapper.style.display = 'flex';
      requestAnimationFrame(function(){
        wrapper.classList.remove('opacity-0');
        panel.classList.remove('translate-y-full');
        panel.classList.add('translate-y-0');
      });
    } else {
      wrapper.classList.add('opacity-0');
      panel.classList.remove('translate-y-0');
      panel.classList.add('translate-y-full');
      setTimeout(function(){ wrapper.classList.add('hidden'); }, 300);
    }
  };

  // ============= KEYBOARD SHORTCUTS =============
  document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') {
      var wrapper = document.getElementById('listViewModalWrapper');
      if (wrapper && !wrapper.classList.contains('hidden')) toggleListView();
    }
  });

  // ============= DEMO SUBMIT BUTTON (step 4) =============
  var submitBtn = document.getElementById('submitBtn');
  if (submitBtn && !submitBtn._patched) {
    submitBtn._patched = true;
    var orig = submitBtn.innerHTML;
    submitBtn.addEventListener('click', function(e) {
      e.preventDefault();
      var cb = document.getElementById('terms');
      if (cb && !cb.checked) { showToast('Please agree to the terms first.'); return; }
      if (submitBtn.disabled) return;
      submitBtn.innerHTML = '<div class="flex items-center justify-center gap-base"><svg class="animate-spin h-5 w-5 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24"><circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle><path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path></svg> Processing...</div>';
      submitBtn.disabled = true;
      setTimeout(function(){
        submitBtn.innerHTML = 'Application Submitted';
        submitBtn.classList.remove('bg-primary', 'bg-primary-container');
        submitBtn.classList.add('bg-secondary');
        showAlert('Application Submitted!', 'Your application for The Lumina - Unit 4B has been successfully submitted!');
      }, 2000);
    });
  }

  // ============= FAVORITES PERSISTENCE =============
  function saveFavorites() {
    var favs = [];
    document.querySelectorAll('.material-symbols-outlined').forEach(function(el) {
      if (el.textContent === 'favorite') {
        var card = el.closest('article, [class*="rounded-xl"], [class*="snap-center"]');
        if (card) {
          var id = card.querySelector('h3') ? card.querySelector('h3').textContent.trim() : '';
          if (id && favs.indexOf(id) === -1) favs.push(id);
        }
      }
    });
    localStorage.setItem('tmFavorites', JSON.stringify(favs));
  }

  function restoreFavorites() {
    try {
      var favs = JSON.parse(localStorage.getItem('tmFavorites')) || [];
      if (!favs.length) return;
      document.querySelectorAll('.material-symbols-outlined').forEach(function(el) {
        if (el.textContent !== 'favorite_border') return;
        var card = el.closest('article, [class*="rounded-xl"], [class*="snap-center"]');
        if (card) {
          var id = card.querySelector('h3') ? card.querySelector('h3').textContent.trim() : '';
          if (favs.indexOf(id) !== -1) {
            el.textContent = 'favorite';
            el.style.setProperty('font-variation-settings', "'FILL' 1");
          }
        }
      });
    } catch(e) {}
  }

  // ============= DARK MODE =============
  function updateDarkModeIcon() {
    var icon = document.getElementById('darkModeIcon');
    if (icon) {
      icon.textContent = document.documentElement.classList.contains('dark') ? 'light_mode' : 'dark_mode';
    }
  }

  window.toggleDarkMode = function() {
    document.documentElement.classList.toggle('dark');
    var isDark = document.documentElement.classList.contains('dark');
    localStorage.setItem('tm-dark-mode', isDark ? 'dark' : 'light');
    updateDarkModeIcon();
  };

  (function initDarkMode() {
    var saved = localStorage.getItem('tm-dark-mode');
    if (saved === 'dark' || (!saved && window.matchMedia('(prefers-color-scheme: dark)').matches)) {
      document.documentElement.classList.add('dark');
    }
    updateDarkModeIcon();
  })();

  // ============= INIT =============
  console.log('TenantMatch App loaded | File: ' + CURRENT_FILE);
  restoreFavorites();

  // Expose utilities for inline handlers
  window.showToast = showToast;
  window.saveFormData = saveFormData;
  window.navigate = navigate;
  window.showAlert = showAlert;
  window.saveFavorites = saveFavorites;
})();
