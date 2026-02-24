<!DOCTYPE html>
<html lang="th">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>LearnHub - ?????????????????????</title>
<link href="https://fonts.googleapis.com/css2?family=Sarabun:wght@300;400;500;600;700;800&family=Chakra+Petch:wght@400;500;600;700&display=swap" rel="stylesheet">
<style>
  :root {
    --primary: #1a56db;
    --primary-dark: #1040b0;
    --primary-light: #e8f0fe;
    --accent: #f59e0b;
    --accent-dark: #d97706;
    --success: #10b981;
    --danger: #ef4444;
    --dark: #0f172a;
    --dark2: #1e293b;
    --dark3: #334155;
    --gray: #64748b;
    --gray-light: #94a3b8;
    --border: #e2e8f0;
    --bg: #f8fafc;
    --white: #ffffff;
    --shadow: 0 4px 24px rgba(15,23,42,0.08);
    --shadow-lg: 0 12px 40px rgba(15,23,42,0.14);
    --radius: 12px;
    --radius-lg: 20px;
  }

  * { margin: 0; padding: 0; box-sizing: border-box; }

  body {
    font-family: 'Sarabun', sans-serif;
    background: var(--bg);
    color: var(--dark);
    min-height: 100vh;
  }

  /* ===== NAVBAR ===== */
  .navbar {
    background: var(--white);
    border-bottom: 1px solid var(--border);
    padding: 0 2rem;
    height: 64px;
    display: flex;
    align-items: center;
    justify-content: space-between;
    position: sticky;
    top: 0;
    z-index: 100;
    box-shadow: 0 2px 8px rgba(15,23,42,0.06);
  }
  .navbar-brand {
    display: flex;
    align-items: center;
    gap: 10px;
    text-decoration: none;
    font-family: 'Chakra Petch', sans-serif;
    font-size: 1.4rem;
    font-weight: 700;
    color: var(--primary);
  }
  .navbar-brand .logo-icon {
    width: 36px; height: 36px;
    background: linear-gradient(135deg, var(--primary), #6366f1);
    border-radius: 8px;
    display: flex; align-items: center; justify-content: center;
    color: white; font-size: 1rem;
  }
  .navbar-nav {
    display: flex; align-items: center; gap: 0.25rem;
    list-style: none;
  }
  .navbar-nav a {
    text-decoration: none;
    color: var(--dark3);
    font-weight: 500;
    padding: 0.5rem 1rem;
    border-radius: 8px;
    transition: all 0.2s;
    font-size: 0.9rem;
  }
  .navbar-nav a:hover, .navbar-nav a.active {
    background: var(--primary-light);
    color: var(--primary);
  }
  .navbar-actions { display: flex; gap: 0.75rem; align-items: center; }
  .btn {
    padding: 0.5rem 1.25rem;
    border-radius: 8px;
    border: none;
    cursor: pointer;
    font-family: 'Sarabun', sans-serif;
    font-weight: 600;
    font-size: 0.875rem;
    transition: all 0.2s;
    display: inline-flex; align-items: center; gap: 6px;
    text-decoration: none;
  }
  .btn-primary {
    background: var(--primary);
    color: white;
  }
  .btn-primary:hover { background: var(--primary-dark); transform: translateY(-1px); box-shadow: 0 4px 12px rgba(26,86,219,0.3); }
  .btn-outline {
    background: transparent;
    border: 1.5px solid var(--border);
    color: var(--dark3);
  }
  .btn-outline:hover { border-color: var(--primary); color: var(--primary); background: var(--primary-light); }
  .btn-accent { background: var(--accent); color: white; }
  .btn-accent:hover { background: var(--accent-dark); }
  .btn-success { background: var(--success); color: white; }
  .btn-danger { background: var(--danger); color: white; }
  .btn-lg { padding: 0.75rem 2rem; font-size: 1rem; border-radius: 10px; }
  .btn-sm { padding: 0.375rem 0.875rem; font-size: 0.8rem; }

  /* ===== PAGES ===== */
  .page { display: none; }
  .page.active { display: block; }

  /* ===== HERO ===== */
  .hero {
    background: linear-gradient(135deg, #0f172a 0%, #1e3a8a 50%, #1d4ed8 100%);
    padding: 6rem 2rem;
    text-align: center;
    color: white;
    position: relative;
    overflow: hidden;
  }
  .hero::before {
    content: '';
    position: absolute; inset: 0;
    background: url("data:image/svg+xml,%3Csvg width='60' height='60' viewBox='0 0 60 60' xmlns='http://www.w3.org/2000/svg'%3E%3Cg fill='none' fill-rule='evenodd'%3E%3Cg fill='%23ffffff' fill-opacity='0.03'%3E%3Ccircle cx='30' cy='30' r='20'/%3E%3C/g%3E%3C/g%3E%3C/svg%3E");
  }
  .hero-content { position: relative; max-width: 700px; margin: 0 auto; }
  .hero-badge {
    display: inline-flex; align-items: center; gap: 6px;
    background: rgba(245,158,11,0.2);
    border: 1px solid rgba(245,158,11,0.4);
    color: #fbbf24;
    padding: 0.375rem 1rem;
    border-radius: 100px;
    font-size: 0.8rem; font-weight: 600;
    margin-bottom: 1.5rem;
  }
  .hero h1 {
    font-family: 'Chakra Petch', sans-serif;
    font-size: 3.2rem;
    font-weight: 700;
    line-height: 1.1;
    margin-bottom: 1.25rem;
  }
  .hero h1 span { color: #fbbf24; }
  .hero p { font-size: 1.1rem; color: rgba(255,255,255,0.75); margin-bottom: 2.5rem; line-height: 1.7; }
  .hero-btns { display: flex; gap: 1rem; justify-content: center; flex-wrap: wrap; }
  .hero-stats {
    display: flex; justify-content: center; gap: 3rem;
    margin-top: 4rem;
    padding-top: 3rem;
    border-top: 1px solid rgba(255,255,255,0.1);
  }
  .stat-item { text-align: center; }
  .stat-item .num {
    font-family: 'Chakra Petch', sans-serif;
    font-size: 2rem; font-weight: 700; color: #fbbf24;
  }
  .stat-item .label { font-size: 0.85rem; color: rgba(255,255,255,0.6); margin-top: 4px; }

  /* ===== SECTION ===== */
  .section { padding: 4rem 2rem; max-width: 1200px; margin: 0 auto; }
  .section-header { margin-bottom: 2.5rem; }
  .section-header h2 {
    font-family: 'Chakra Petch', sans-serif;
    font-size: 1.8rem; font-weight: 700; color: var(--dark);
    margin-bottom: 0.5rem;
  }
  .section-header p { color: var(--gray); font-size: 1rem; }

  /* ===== CARDS ===== */
  .grid-3 { display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: 1.5rem; }
  .grid-4 { display: grid; grid-template-columns: repeat(auto-fill, minmax(240px, 1fr)); gap: 1.25rem; }

  .course-card {
    background: var(--white);
    border-radius: var(--radius-lg);
    overflow: hidden;
    border: 1px solid var(--border);
    transition: all 0.25s;
    cursor: pointer;
  }
  .course-card:hover { transform: translateY(-4px); box-shadow: var(--shadow-lg); border-color: var(--primary); }
  .course-thumb {
    height: 180px;
    display: flex; align-items: center; justify-content: center;
    font-size: 3rem;
    position: relative;
  }
  .course-thumb.blue { background: linear-gradient(135deg, #dbeafe, #bfdbfe); }
  .course-thumb.green { background: linear-gradient(135deg, #d1fae5, #a7f3d0); }
  .course-thumb.purple { background: linear-gradient(135deg, #ede9fe, #ddd6fe); }
  .course-thumb.orange { background: linear-gradient(135deg, #fff7ed, #fed7aa); }
  .course-badge {
    position: absolute; top: 12px; left: 12px;
    background: var(--white);
    border-radius: 6px;
    padding: 3px 10px;
    font-size: 0.75rem; font-weight: 600;
    color: var(--primary);
    border: 1px solid var(--primary-light);
  }
  .course-body { padding: 1.25rem; }
  .course-title { font-weight: 700; font-size: 1rem; margin-bottom: 0.5rem; color: var(--dark); }
  .course-meta { display: flex; gap: 1rem; color: var(--gray); font-size: 0.8rem; margin-bottom: 1rem; }
  .course-meta span { display: flex; align-items: center; gap: 4px; }
  .course-progress { margin-bottom: 1rem; }
  .progress-bar {
    height: 6px;
    background: var(--border);
    border-radius: 100px;
    overflow: hidden;
    margin-top: 4px;
  }
  .progress-fill {
    height: 100%;
    background: linear-gradient(90deg, var(--primary), #6366f1);
    border-radius: 100px;
    transition: width 0.5s ease;
  }
  .progress-label { font-size: 0.75rem; color: var(--gray); display: flex; justify-content: space-between; }

  /* ===== DASHBOARD ===== */
  .dashboard-layout {
    display: grid;
    grid-template-columns: 260px 1fr;
    min-height: calc(100vh - 64px);
  }
  .sidebar {
    background: var(--white);
    border-right: 1px solid var(--border);
    padding: 1.5rem 0;
    position: sticky;
    top: 64px;
    height: calc(100vh - 64px);
    overflow-y: auto;
  }
  .sidebar-section { padding: 0 1rem; margin-bottom: 0.5rem; }
  .sidebar-label {
    font-size: 0.7rem; font-weight: 700;
    text-transform: uppercase; letter-spacing: 0.1em;
    color: var(--gray-light);
    padding: 0.5rem 0.75rem;
  }
  .sidebar-item {
    display: flex; align-items: center; gap: 10px;
    padding: 0.625rem 0.75rem;
    border-radius: 8px;
    cursor: pointer;
    transition: all 0.15s;
    color: var(--dark3);
    font-weight: 500;
    font-size: 0.875rem;
    text-decoration: none;
  }
  .sidebar-item:hover { background: var(--bg); color: var(--primary); }
  .sidebar-item.active { background: var(--primary-light); color: var(--primary); font-weight: 600; }
  .sidebar-item .icon { font-size: 1rem; width: 20px; text-align: center; }
  .sidebar-badge {
    margin-left: auto;
    background: var(--primary);
    color: white;
    font-size: 0.65rem; font-weight: 700;
    padding: 2px 7px;
    border-radius: 100px;
  }
  .dashboard-main { padding: 2rem; background: var(--bg); }

  /* ===== STATS CARDS ===== */
  .stats-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(200px, 1fr)); gap: 1.25rem; margin-bottom: 2rem; }
  .stat-card {
    background: var(--white);
    border-radius: var(--radius);
    padding: 1.25rem;
    border: 1px solid var(--border);
    display: flex; align-items: flex-start; gap: 1rem;
  }
  .stat-icon {
    width: 44px; height: 44px;
    border-radius: 10px;
    display: flex; align-items: center; justify-content: center;
    font-size: 1.25rem; flex-shrink: 0;
  }
  .stat-icon.blue { background: #dbeafe; }
  .stat-icon.green { background: #d1fae5; }
  .stat-icon.orange { background: #fff7ed; }
  .stat-icon.purple { background: #ede9fe; }
  .stat-value { font-family: 'Chakra Petch', sans-serif; font-size: 1.5rem; font-weight: 700; color: var(--dark); }
  .stat-label { font-size: 0.8rem; color: var(--gray); margin-top: 2px; }

  /* ===== TABLE ===== */
  .table-wrapper {
    background: var(--white);
    border-radius: var(--radius);
    border: 1px solid var(--border);
    overflow: hidden;
  }
  table { width: 100%; border-collapse: collapse; }
  th {
    background: var(--bg);
    padding: 0.875rem 1.25rem;
    text-align: left;
    font-size: 0.8rem; font-weight: 700;
    text-transform: uppercase; letter-spacing: 0.05em;
    color: var(--gray);
    border-bottom: 1px solid var(--border);
  }
  td {
    padding: 1rem 1.25rem;
    font-size: 0.875rem;
    border-bottom: 1px solid var(--border);
    color: var(--dark);
  }
  tr:last-child td { border-bottom: none; }
  tr:hover td { background: var(--bg); }
  .badge {
    display: inline-flex; align-items: center;
    padding: 3px 10px;
    border-radius: 100px;
    font-size: 0.75rem; font-weight: 600;
  }
  .badge-success { background: #d1fae5; color: #065f46; }
  .badge-warning { background: #fff7ed; color: #92400e; }
  .badge-info { background: #dbeafe; color: #1e40af; }
  .badge-danger { background: #fee2e2; color: #991b1b; }

  /* ===== CLASSROOM ===== */
  .classroom-layout {
    display: grid;
    grid-template-columns: 1fr 340px;
    gap: 1.5rem;
  }
  .video-player {
    background: #0f172a;
    border-radius: var(--radius-lg);
    aspect-ratio: 16/9;
    display: flex; align-items: center; justify-content: center;
    color: white; font-size: 3rem;
    cursor: pointer;
    position: relative;
    overflow: hidden;
  }
  .video-player::before {
    content: '';
    position: absolute; inset: 0;
    background: linear-gradient(135deg, #1e3a8a, #312e81);
  }
  .play-btn {
    position: relative; z-index: 1;
    width: 70px; height: 70px;
    background: rgba(255,255,255,0.15);
    backdrop-filter: blur(10px);
    border: 2px solid rgba(255,255,255,0.3);
    border-radius: 50%;
    display: flex; align-items: center; justify-content: center;
    font-size: 1.75rem;
    transition: all 0.2s;
    cursor: pointer;
  }
  .play-btn:hover { background: rgba(255,255,255,0.25); transform: scale(1.05); }
  .lesson-list {
    background: var(--white);
    border-radius: var(--radius-lg);
    border: 1px solid var(--border);
    overflow: hidden;
  }
  .lesson-list-header {
    padding: 1.25rem;
    border-bottom: 1px solid var(--border);
    font-weight: 700;
  }
  .lesson-item {
    display: flex; align-items: center; gap: 12px;
    padding: 0.875rem 1.25rem;
    border-bottom: 1px solid var(--border);
    cursor: pointer;
    transition: all 0.15s;
  }
  .lesson-item:last-child { border-bottom: none; }
  .lesson-item:hover { background: var(--bg); }
  .lesson-item.active { background: var(--primary-light); }
  .lesson-num {
    width: 32px; height: 32px;
    border-radius: 8px;
    background: var(--bg);
    display: flex; align-items: center; justify-content: center;
    font-size: 0.8rem; font-weight: 700;
    color: var(--gray);
    flex-shrink: 0;
  }
  .lesson-item.active .lesson-num { background: var(--primary); color: white; }
  .lesson-item.done .lesson-num { background: var(--success); color: white; }
  .lesson-info { flex: 1; }
  .lesson-name { font-size: 0.875rem; font-weight: 600; color: var(--dark); }
  .lesson-dur { font-size: 0.75rem; color: var(--gray); }

  /* ===== QUIZ ===== */
  .quiz-container {
    max-width: 700px; margin: 0 auto;
    background: var(--white);
    border-radius: var(--radius-lg);
    border: 1px solid var(--border);
    overflow: hidden;
  }
  .quiz-header {
    background: linear-gradient(135deg, var(--primary), #6366f1);
    padding: 1.75rem 2rem;
    color: white;
  }
  .quiz-progress-bar {
    height: 6px;
    background: rgba(255,255,255,0.2);
    border-radius: 100px;
    margin-top: 1rem;
    overflow: hidden;
  }
  .quiz-progress-fill {
    height: 100%;
    background: #fbbf24;
    border-radius: 100px;
    transition: width 0.4s;
  }
  .quiz-body { padding: 2rem; }
  .question-text {
    font-size: 1.1rem; font-weight: 600;
    color: var(--dark);
    margin-bottom: 1.5rem;
    line-height: 1.6;
  }
  .choices { display: flex; flex-direction: column; gap: 0.75rem; }
  .choice {
    display: flex; align-items: center; gap: 12px;
    padding: 1rem 1.25rem;
    border: 2px solid var(--border);
    border-radius: var(--radius);
    cursor: pointer;
    transition: all 0.15s;
    font-size: 0.9rem;
    font-weight: 500;
  }
  .choice:hover { border-color: var(--primary); background: var(--primary-light); }
  .choice.selected { border-color: var(--primary); background: var(--primary-light); color: var(--primary); }
  .choice.correct { border-color: var(--success); background: #d1fae5; color: #065f46; }
  .choice.wrong { border-color: var(--danger); background: #fee2e2; color: #991b1b; }
  .choice-letter {
    width: 30px; height: 30px;
    border-radius: 6px;
    background: var(--bg);
    display: flex; align-items: center; justify-content: center;
    font-size: 0.8rem; font-weight: 700;
    flex-shrink: 0;
  }
  .choice.selected .choice-letter { background: var(--primary); color: white; }
  .quiz-footer {
    padding: 1.25rem 2rem;
    border-top: 1px solid var(--border);
    display: flex; justify-content: space-between; align-items: center;
  }

  /* ===== AUTH ===== */
  .auth-page {
    min-height: calc(100vh - 64px);
    display: flex; align-items: center; justify-content: center;
    background: linear-gradient(135deg, #f0f4ff 0%, #fafbff 100%);
    padding: 2rem;
  }
  .auth-card {
    background: var(--white);
    border-radius: var(--radius-lg);
    border: 1px solid var(--border);
    box-shadow: var(--shadow-lg);
    padding: 2.5rem;
    width: 100%; max-width: 440px;
  }
  .auth-logo { text-align: center; margin-bottom: 2rem; }
  .auth-logo .logo-icon {
    width: 56px; height: 56px;
    background: linear-gradient(135deg, var(--primary), #6366f1);
    border-radius: 14px;
    display: flex; align-items: center; justify-content: center;
    color: white; font-size: 1.5rem;
    margin: 0 auto 1rem;
  }
  .auth-logo h2 {
    font-family: 'Chakra Petch', sans-serif;
    font-size: 1.5rem; font-weight: 700; color: var(--dark);
  }
  .auth-logo p { color: var(--gray); font-size: 0.875rem; margin-top: 4px; }
  .form-group { margin-bottom: 1.25rem; }
  .form-label { display: block; font-size: 0.875rem; font-weight: 600; color: var(--dark); margin-bottom: 6px; }
  .form-control {
    width: 100%;
    padding: 0.75rem 1rem;
    border: 1.5px solid var(--border);
    border-radius: 8px;
    font-family: 'Sarabun', sans-serif;
    font-size: 0.9rem;
    color: var(--dark);
    background: var(--white);
    transition: all 0.15s;
    outline: none;
  }
  .form-control:focus { border-color: var(--primary); box-shadow: 0 0 0 3px rgba(26,86,219,0.1); }
  .form-control::placeholder { color: var(--gray-light); }
  .input-icon { position: relative; }
  .input-icon .form-control { padding-left: 2.75rem; }
  .input-icon .icon {
    position: absolute; left: 0.875rem; top: 50%;
    transform: translateY(-50%);
    color: var(--gray-light);
  }
  .divider { display: flex; align-items: center; gap: 1rem; margin: 1.5rem 0; color: var(--gray-light); font-size: 0.8rem; }
  .divider::before, .divider::after { content: ''; flex: 1; height: 1px; background: var(--border); }
  .auth-switch { text-align: center; margin-top: 1.5rem; font-size: 0.875rem; color: var(--gray); }
  .auth-switch a { color: var(--primary); font-weight: 600; text-decoration: none; }

  /* ===== RESULT ===== */
  .result-card {
    max-width: 500px; margin: 3rem auto;
    background: var(--white);
    border-radius: var(--radius-lg);
    border: 1px solid var(--border);
    padding: 3rem 2.5rem;
    text-align: center;
    box-shadow: var(--shadow);
  }
  .result-score {
    width: 120px; height: 120px;
    border-radius: 50%;
    background: linear-gradient(135deg, var(--primary), #6366f1);
    display: flex; align-items: center; justify-content: center;
    margin: 0 auto 1.5rem;
    flex-direction: column;
  }
  .result-score .num { font-family: 'Chakra Petch', sans-serif; font-size: 2rem; font-weight: 700; color: white; }
  .result-score .label { font-size: 0.75rem; color: rgba(255,255,255,0.7); }

  /* ===== UPLOAD ===== */
  .upload-zone {
    border: 2px dashed var(--border);
    border-radius: var(--radius-lg);
    padding: 3rem;
    text-align: center;
    transition: all 0.2s;
    cursor: pointer;
    background: var(--bg);
  }
  .upload-zone:hover { border-color: var(--primary); background: var(--primary-light); }
  .upload-icon { font-size: 3rem; margin-bottom: 1rem; }
  .upload-text { font-size: 1rem; font-weight: 600; color: var(--dark); margin-bottom: 0.5rem; }
  .upload-subtext { font-size: 0.875rem; color: var(--gray); }

  /* ===== MISC ===== */
  .card {
    background: var(--white);
    border-radius: var(--radius);
    border: 1px solid var(--border);
    padding: 1.5rem;
    box-shadow: var(--shadow);
  }
  .card-header {
    display: flex; justify-content: space-between; align-items: center;
    margin-bottom: 1.25rem;
  }
  .card-title { font-weight: 700; font-size: 1rem; color: var(--dark); }
  .avatar {
    width: 36px; height: 36px;
    border-radius: 50%;
    background: linear-gradient(135deg, var(--primary), #6366f1);
    display: flex; align-items: center; justify-content: center;
    color: white; font-weight: 700; font-size: 0.875rem;
    flex-shrink: 0;
  }
  .user-info { display: flex; align-items: center; gap: 10px; }
  .user-name { font-weight: 600; font-size: 0.875rem; }
  .user-role { font-size: 0.75rem; color: var(--gray); }

  /* tabs */
  .tabs { display: flex; gap: 0.25rem; border-bottom: 2px solid var(--border); margin-bottom: 1.5rem; }
  .tab {
    padding: 0.625rem 1.25rem;
    cursor: pointer;
    font-size: 0.875rem; font-weight: 600;
    color: var(--gray);
    border-bottom: 2px solid transparent;
    margin-bottom: -2px;
    transition: all 0.15s;
  }
  .tab:hover { color: var(--primary); }
  .tab.active { color: var(--primary); border-bottom-color: var(--primary); }

  .tab-content { display: none; }
  .tab-content.active { display: block; }

  /* notification */
  .notification {
    position: fixed; top: 80px; right: 20px;
    background: var(--white);
    border: 1px solid var(--border);
    border-left: 4px solid var(--success);
    border-radius: var(--radius);
    padding: 1rem 1.25rem;
    box-shadow: var(--shadow-lg);
    z-index: 1000;
    display: none;
    min-width: 280px;
  }
  .notification.show { display: block; animation: slideIn 0.3s ease; }
  @keyframes slideIn { from { transform: translateX(100%); opacity: 0; } to { transform: translateX(0); opacity: 1; } }

  .empty-state { text-align: center; padding: 3rem 1rem; color: var(--gray); }
  .empty-state .icon { font-size: 3rem; margin-bottom: 1rem; }

  @media (max-width: 768px) {
    .dashboard-layout { grid-template-columns: 1fr; }
    .sidebar { display: none; }
    .classroom-layout { grid-template-columns: 1fr; }
    .hero h1 { font-size: 2rem; }
    .hero-stats { gap: 1.5rem; }
  }
</style>
</head>
<body>

<!-- NAVBAR -->
<nav class="navbar">
  <a class="navbar-brand" href="#" onclick="showPage('home')">
    <div class="logo-icon">?</div>
    LearnHub
  </a>
  <ul class="navbar-nav" id="mainNav">
    <li><a href="#" onclick="showPage('home')" class="active" id="nav-home">????????</a></li>
    <li><a href="#" onclick="showPage('courses')" id="nav-courses">??????????</a></li>
    <li><a href="#" onclick="showPage('dashboard')" id="nav-dashboard" style="display:none">????????</a></li>
  </ul>
  <div class="navbar-actions" id="navActions">
    <button class="btn btn-outline" onclick="showPage('login')">???????????</button>
    <button class="btn btn-primary" onclick="showPage('register')">???????????</button>
  </div>
  <div class="navbar-actions" id="navActionsLoggedIn" style="display:none">
    <div class="user-info">
      <div class="avatar" id="userAvatar">?</div>
      <div>
        <div class="user-name" id="userNameDisplay">????????</div>
        <div class="user-role">????????</div>
      </div>
    </div>
    <button class="btn btn-outline btn-sm" onclick="logout()">??????????</button>
  </div>
</nav>

<!-- NOTIFICATION -->
<div class="notification" id="notification">
  <strong id="notifTitle">? ??????</strong>
  <div id="notifMsg" style="font-size:0.8rem;color:var(--gray);margin-top:2px;"></div>
</div>

<!-- ======================== PAGE: HOME ======================== -->
<div class="page active" id="page-home">
  <!-- Hero -->
  <div class="hero">
    <div class="hero-content">
      <div class="hero-badge">? ????????????????????????????????</div>
      <h1>?????????????<span>????????</span><br>??? LearnHub</h1>
      <p>??????????????????? ??????????????-????????? ?????????????????? ?????????????????????????????????</p>
      <div class="hero-btns">
        <button class="btn btn-accent btn-lg" onclick="showPage('courses')">? ?????????????</button>
        <button class="btn btn-outline btn-lg" style="border-color:rgba(255,255,255,0.3);color:white" onclick="showPage('courses')">? ??????????????</button>
      </div>
      <div class="hero-stats">
        <div class="stat-item"><div class="num">1,200+</div><div class="label">????????</div></div>
        <div class="stat-item"><div class="num">50+</div><div class="label">??????????</div></div>
        <div class="stat-item"><div class="num">30+</div><div class="label">??????</div></div>
        <div class="stat-item"><div class="num">98%</div><div class="label">???????????</div></div>
      </div>
    </div>
  </div>

  <!-- Featured Courses -->
  <div class="section">
    <div class="section-header" style="display:flex;justify-content:space-between;align-items:center">
      <div>
        <h2>????????????</h2>
        <p>??????????????????????????????????????????????</p>
      </div>
      <button class="btn btn-outline" onclick="showPage('courses')">????????? ?</button>
    </div>
    <div class="grid-3">
      <div class="course-card" onclick="showClassroom(1)">
        <div class="course-thumb blue"><span>?</span><span class="course-badge">???????????</span></div>
        <div class="course-body">
          <div class="course-title">??????????????????? C</div>
          <div class="course-meta">
            <span>? 12 ???????</span>
            <span>? 8 ??.</span>
            <span>? 4.8</span>
          </div>
          <button class="btn btn-primary" style="width:100%">??????????</button>
        </div>
      </div>
      <div class="course-card" onclick="showClassroom(2)">
        <div class="course-thumb green"><span>?</span><span class="course-badge">????</span></div>
        <div class="course-body">
          <div class="course-title">????????????????</div>
          <div class="course-meta">
            <span>? 18 ???????</span>
            <span>? 15 ??.</span>
            <span>? 4.9</span>
          </div>
          <button class="btn btn-primary" style="width:100%">??????????</button>
        </div>
      </div>
      <div class="course-card" onclick="showClassroom(3)">
        <div class="course-thumb purple"><span>??</span><span class="course-badge">?????????</span></div>
        <div class="course-body">
          <div class="course-title">??????????????????</div>
          <div class="course-meta">
            <span>? 10 ???????</span>
            <span>? 6 ??.</span>
            <span>? 4.7</span>
          </div>
          <button class="btn btn-primary" style="width:100%">??????????</button>
        </div>
      </div>
    </div>
  </div>

  <!-- Features -->
  <div style="background: var(--white); border-top: 1px solid var(--border); border-bottom: 1px solid var(--border);">
    <div class="section">
      <div class="section-header" style="text-align:center">
        <h2>????????????????????</h2>
        <p>?????????????????????? ????????????????????????????????</p>
      </div>
      <div class="grid-4">
        <div class="card" style="text-align:center;border:none;box-shadow:none">
          <div style="font-size:2.5rem;margin-bottom:1rem">?</div>
          <div style="font-weight:700;margin-bottom:0.5rem">Pre-Test & Post-Test</div>
          <div style="font-size:0.875rem;color:var(--gray)">?????????????????????????????????????????????</div>
        </div>
        <div class="card" style="text-align:center;border:none;box-shadow:none">
          <div style="font-size:2.5rem;margin-bottom:1rem">?</div>
          <div style="font-weight:700;margin-bottom:0.5rem">??????????????????</div>
          <div style="font-size:0.875rem;color:var(--gray)">??????????????????????????????? Real-time</div>
        </div>
        <div class="card" style="text-align:center;border:none;box-shadow:none">
          <div style="font-size:2.5rem;margin-bottom:1rem">?</div>
          <div style="font-weight:700;margin-bottom:0.5rem">???????????????</div>
          <div style="font-size:0.875rem;color:var(--gray)">?????? ?????? ????????????????????????????</div>
        </div>
        <div class="card" style="text-align:center;border:none;box-shadow:none">
          <div style="font-size:2.5rem;margin-bottom:1rem">?</div>
          <div style="font-weight:700;margin-bottom:0.5rem">???????????????</div>
          <div style="font-size:0.875rem;color:var(--gray)">??????????????????????????????????????</div>
        </div>
      </div>
    </div>
  </div>
</div>

<!-- ======================== PAGE: COURSES ======================== -->
<div class="page" id="page-courses">
  <div class="section">
    <div class="section-header">
      <h2>?????????????????</h2>
      <p>???????????????????????????????????????</p>
    </div>
    <div class="grid-3">
      <div class="course-card" onclick="showClassroom(1)">
        <div class="course-thumb blue"><span>?</span><span class="course-badge">???????????</span></div>
        <div class="course-body">
          <div class="course-title">??????????????????? C</div>
          <div class="course-meta">
            <span>? 12 ???????</span><span>? 8 ??.</span><span>? 4.8</span>
          </div>
          <button class="btn btn-primary" style="width:100%">?????????</button>
        </div>
      </div>
      <div class="course-card" onclick="showClassroom(2)">
        <div class="course-thumb green"><span>?</span><span class="course-badge">????</span></div>
        <div class="course-body">
          <div class="course-title">????????????????</div>
          <div class="course-meta">
            <span>? 18 ???????</span><span>? 15 ??.</span><span>? 4.9</span>
          </div>
          <button class="btn btn-primary" style="width:100%">?????????</button>
        </div>
      </div>
      <div class="course-card" onclick="showClassroom(3)">
        <div class="course-thumb purple"><span>??</span><span class="course-badge">?????????</span></div>
        <div class="course-body">
          <div class="course-title">??????????????????</div>
          <div class="course-meta">
            <span>? 10 ???????</span><span>? 6 ??.</span><span>? 4.7</span>
          </div>
          <button class="btn btn-primary" style="width:100%">?????????</button>
        </div>
      </div>
    </div>
  </div>
</div>

<!-- ======================== PAGE: CLASSROOM ======================== -->
<div class="page" id="page-classroom">
  <div class="section">
    <div style="margin-bottom:1.5rem;display:flex;align-items:center;gap:10px">
      <button class="btn btn-outline btn-sm" onclick="showPage('courses')">? ????</button>
      <div>
        <h2 style="font-size:1.2rem;font-weight:700" id="classroomTitle">??????????????????? C</h2>
        <p style="font-size:0.8rem;color:var(--gray)">????? ID: 1 ? ???????????</p>
      </div>
    </div>

    <!-- Pre-test alert -->
    <div id="pretestAlert" style="background: linear-gradient(135deg,#fff7ed,#fffbeb);border:1.5px solid #fed7aa;border-radius:var(--radius);padding:1.25rem;margin-bottom:1.5rem;display:flex;align-items:center;gap:12px">
      <span style="font-size:1.5rem">?</span>
      <div style="flex:1">
        <div style="font-weight:700;color:#92400e">??????????????????? (Pre-Test)</div>
        <div style="font-size:0.8rem;color:#b45309;margin-top:2px">?????????????????????????????? ????????????? 10 ????</div>
      </div>
      <button class="btn btn-accent btn-sm" onclick="showQuiz('pre')">??????????</button>
    </div>

    <div class="classroom-layout">
      <!-- Video / Content -->
      <div>
        <div class="video-player" onclick="playVideo()">
          <div class="play-btn">?</div>
        </div>
        <div style="margin-top:1.25rem">
          <div class="tabs">
            <div class="tab active" onclick="switchTab(this,'tab-overview')">??????</div>
            <div class="tab" onclick="switchTab(this,'tab-materials')">??????/????</div>
            <div class="tab" onclick="switchTab(this,'tab-notes')">??????????</div>
          </div>
          <div class="tab-content active" id="tab-overview">
            <h3 style="font-weight:700;margin-bottom:0.75rem">????? 1: ????????????? C</h3>
            <p style="color:var(--gray);line-height:1.8;font-size:0.9rem">?????????????????????????????????????????????? C ??????????????????????????????????????????????????????????? ????????? ?????? C++, Java, Python ???????</p>
            <div style="margin-top:1.5rem">
              <div style="font-weight:700;margin-bottom:1rem">???????????????????????</div>
              <div style="display:flex;flex-direction:column;gap:8px">
                <div style="display:flex;align-items:center;gap:8px;font-size:0.875rem"><span style="color:var(--success)">?</span> ???????????????????????????????????? C</div>
                <div style="display:flex;align-items:center;gap:8px;font-size:0.875rem"><span style="color:var(--success)">?</span> ???????????? Hello World ???</div>
                <div style="display:flex;align-items:center;gap:8px;font-size:0.875rem"><span style="color:var(--success)">?</span> ????????????????????????????????</div>
              </div>
            </div>
          </div>
          <div class="tab-content" id="tab-materials">
            <div style="display:flex;flex-direction:column;gap:0.75rem">
              <div style="display:flex;align-items:center;gap:12px;padding:1rem;border:1px solid var(--border);border-radius:var(--radius);cursor:pointer" onmouseover="this.style.background='var(--bg)'" onmouseout="this.style.background=''">
                <span style="font-size:1.5rem">?</span>
                <div style="flex:1"><div style="font-weight:600;font-size:0.875rem">????????????????? ????? 1</div><div style="font-size:0.75rem;color:var(--gray)">PDF ? 2.4 MB</div></div>
                <button class="btn btn-outline btn-sm">?????????</button>
              </div>
              <div style="display:flex;align-items:center;gap:12px;padding:1rem;border:1px solid var(--border);border-radius:var(--radius);cursor:pointer" onmouseover="this.style.background='var(--bg)'" onmouseout="this.style.background=''">
                <span style="font-size:1.5rem">?</span>
                <div style="flex:1"><div style="font-weight:600;font-size:0.875rem">Source Code ????????</div><div style="font-size:0.75rem;color:var(--gray)">ZIP ? 156 KB</div></div>
                <button class="btn btn-outline btn-sm">?????????</button>
              </div>
            </div>
            <!-- Upload zone -->
            <div class="upload-zone" style="margin-top:1.5rem" onclick="notify('???????????','?????????????????????????????')">
              <div class="upload-icon">?</div>
              <div class="upload-text">?????????????????</div>
              <div class="upload-subtext">?????????????????? ??????????????????????<br>?????? PDF, DOC, ZIP ??????????? 50MB</div>
            </div>
          </div>
          <div class="tab-content" id="tab-notes">
            <textarea class="form-control" rows="8" placeholder="??????????????????..." style="resize:vertical"></textarea>
            <button class="btn btn-primary btn-sm" style="margin-top:0.75rem" onclick="notify('??????????','????????????????????????????????')">? ??????????</button>
          </div>
        </div>
      </div>

      <!-- Lesson list -->
      <div>
        <div class="lesson-list">
          <div class="lesson-list-header">? ?????????????? <span style="color:var(--gray);font-weight:400;font-size:0.8rem">(12 ??)</span></div>
          <div class="lesson-item done"><div class="lesson-num">?</div><div class="lesson-info"><div class="lesson-name">????? 1: ????????????? C</div><div class="lesson-dur">? 45 ????</div></div></div>
          <div class="lesson-item active"><div class="lesson-num">2</div><div class="lesson-info"><div class="lesson-name">????? 2: ???????????????????</div><div class="lesson-dur">? 50 ????</div></div></div>
          <div class="lesson-item"><div class="lesson-num">3</div><div class="lesson-info"><div class="lesson-name">????? 3: ???????????????</div><div class="lesson-dur">? 40 ????</div></div></div>
          <div class="lesson-item"><div class="lesson-num">4</div><div class="lesson-info"><div class="lesson-name">????? 4: ???????????????</div><div class="lesson-dur">? 60 ????</div></div></div>
          <div class="lesson-item"><div class="lesson-num">5</div><div class="lesson-info"><div class="lesson-name">????? 5: ??? (Loop)</div><div class="lesson-dur">? 55 ????</div></div></div>
          <div class="lesson-item"><div class="lesson-num">6</div><div class="lesson-info"><div class="lesson-name">????? 6: ???????? (Function)</div><div class="lesson-dur">? 65 ????</div></div></div>
        </div>
        <button class="btn btn-success" style="width:100%;margin-top:1rem" onclick="showQuiz('post')">
          ? ???????????????????
        </button>
      </div>
    </div>
  </div>
</div>

<!-- ======================== PAGE: QUIZ ======================== -->
<div class="page" id="page-quiz">
  <div class="section">
    <div class="quiz-container">
      <div class="quiz-header">
        <div style="display:flex;justify-content:space-between;align-items:center">
          <div>
            <div style="font-size:0.8rem;opacity:0.75;margin-bottom:4px" id="quizType">? Pre-Test</div>
            <div style="font-weight:700;font-size:1.1rem">??????????????????? C</div>
          </div>
          <div style="text-align:right">
            <div style="font-size:1.5rem;font-weight:700;font-family:'Chakra Petch',sans-serif" id="quizNum">1/5</div>
            <div style="font-size:0.75rem;opacity:0.7">??????</div>
          </div>
        </div>
        <div class="quiz-progress-bar"><div class="quiz-progress-fill" id="quizProgressFill" style="width:20%"></div></div>
      </div>
      <div class="quiz-body">
        <div class="question-text" id="questionText">??????????? C ???????????????????</div>
        <div class="choices" id="choicesContainer">
          <div class="choice" onclick="selectChoice(this,false)"><div class="choice-letter">A</div> ?.?. 1960</div>
          <div class="choice" onclick="selectChoice(this,false)"><div class="choice-letter">B</div> ?.?. 1972</div>
          <div class="choice" onclick="selectChoice(this,true)"><div class="choice-letter">C</div> ?.?. 1969</div>
          <div class="choice" onclick="selectChoice(this,false)"><div class="choice-letter">D</div> ?.?. 1980</div>
        </div>
      </div>
      <div class="quiz-footer">
        <button class="btn btn-outline" onclick="goBack()">? ???</button>
        <div style="display:flex;gap:0.75rem">
          <button class="btn btn-primary" id="nextBtn" onclick="nextQuestion()" disabled>????? ?</button>
        </div>
      </div>
    </div>
  </div>
</div>

<!-- ======================== PAGE: QUIZ RESULT ======================== -->
<div class="page" id="page-result">
  <div class="section">
    <div class="result-card">
      <div style="font-size:3rem;margin-bottom:1rem" id="resultEmoji">?</div>
      <h2 style="font-family:'Chakra Petch',sans-serif;margin-bottom:0.5rem" id="resultTitle">?????????!</h2>
      <p style="color:var(--gray);margin-bottom:2rem" id="resultSub">?????????????????????</p>
      <div class="result-score">
        <div class="num" id="resultScore">80</div>
        <div class="label">?????</div>
      </div>
      <div style="display:grid;grid-template-columns:1fr 1fr;gap:1rem;margin:1.5rem 0">
        <div style="padding:1rem;background:var(--bg);border-radius:var(--radius);text-align:center">
          <div style="font-size:1.5rem;font-weight:700;color:var(--success)" id="correctCount">4</div>
          <div style="font-size:0.8rem;color:var(--gray)">??????</div>
        </div>
        <div style="padding:1rem;background:var(--bg);border-radius:var(--radius);text-align:center">
          <div style="font-size:1.5rem;font-weight:700;color:var(--danger)" id="wrongCount">1</div>
          <div style="font-size:0.8rem;color:var(--gray)">??????</div>
        </div>
      </div>
      <div style="display:flex;gap:1rem;flex-direction:column">
        <button class="btn btn-primary" onclick="showPage('classroom')">? ??????????????</button>
        <button class="btn btn-outline" onclick="showPage('dashboard');switchDashTab('history')">? ?????????????????</button>
      </div>
    </div>
  </div>
</div>

<!-- ======================== PAGE: DASHBOARD ======================== -->
<div class="page" id="page-dashboard">
  <div class="dashboard-layout">
    <!-- Sidebar -->
    <div class="sidebar">
      <div style="padding:0 1rem 1.5rem;border-bottom:1px solid var(--border)">
        <div class="user-info" style="padding:0.75rem">
          <div class="avatar" style="width:44px;height:44px;font-size:1rem" id="sidebarAvatar">?</div>
          <div>
            <div style="font-weight:700" id="sidebarName">????????</div>
            <div style="font-size:0.75rem;color:var(--gray)">???????? ? ???????? ?.?. 2026</div>
          </div>
        </div>
      </div>
      <div class="sidebar-section" style="margin-top:1rem">
        <div class="sidebar-label">????????</div>
        <a class="sidebar-item active" href="#" onclick="switchDashTab('overview');setSideActive(this)">
          <span class="icon">?</span> ??????
        </a>
        <a class="sidebar-item" href="#" onclick="switchDashTab('mycourses');setSideActive(this)">
          <span class="icon">?</span> ???????????
        </a>
        <a class="sidebar-item" href="#" onclick="switchDashTab('history');setSideActive(this)">
          <span class="icon">?</span> ???????????????
        </a>
        <a class="sidebar-item" href="#" onclick="switchDashTab('results');setSideActive(this)">
          <span class="icon">?</span> ?????????????
          <span class="sidebar-badge">3</span>
        </a>
        <a class="sidebar-item" href="#" onclick="switchDashTab('profile');setSideActive(this)">
          <span class="icon">?</span> ???????
        </a>
      </div>
    </div>

    <!-- Main -->
    <div class="dashboard-main">

      <!-- Overview Tab -->
      <div id="dash-overview">
        <div style="margin-bottom:2rem">
          <h2 style="font-family:'Chakra Petch',sans-serif;font-size:1.5rem;font-weight:700">??????, <span id="greetName">????????</span> ?</h2>
          <p style="color:var(--gray);font-size:0.875rem;margin-top:4px">????????????????????????????????????????????</p>
        </div>
        <div class="stats-grid">
          <div class="stat-card">
            <div class="stat-icon blue">?</div>
            <div><div class="stat-value">3</div><div class="stat-label">?????????????????</div></div>
          </div>
          <div class="stat-card">
            <div class="stat-icon green">?</div>
            <div><div class="stat-value">1</div><div class="stat-label">???????????????</div></div>
          </div>
          <div class="stat-card">
            <div class="stat-icon orange">?</div>
            <div><div class="stat-value">5</div><div class="stat-label">?????????????</div></div>
          </div>
          <div class="stat-card">
            <div class="stat-icon purple">?</div>
            <div><div class="stat-value">82%</div><div class="stat-label">???????????</div></div>
          </div>
        </div>

        <!-- Continue learning -->
        <div class="card">
          <div class="card-header">
            <div class="card-title">??????????????</div>
            <button class="btn btn-outline btn-sm" onclick="showPage('courses')">??????????????</button>
          </div>
          <div style="display:flex;flex-direction:column;gap:1rem">
            <div style="display:flex;align-items:center;gap:1rem;padding:1rem;border:1px solid var(--border);border-radius:var(--radius)">
              <div style="width:50px;height:50px;background:#dbeafe;border-radius:10px;display:flex;align-items:center;justify-content:center;font-size:1.5rem;flex-shrink:0">?</div>
              <div style="flex:1">
                <div style="font-weight:700;font-size:0.9rem">??????????????????? C</div>
                <div class="course-progress">
                  <div class="progress-label"><span>????????????</span><span>33%</span></div>
                  <div class="progress-bar"><div class="progress-fill" style="width:33%"></div></div>
                </div>
              </div>
              <button class="btn btn-primary btn-sm" onclick="showClassroom(1)">????????</button>
            </div>
            <div style="display:flex;align-items:center;gap:1rem;padding:1rem;border:1px solid var(--border);border-radius:var(--radius)">
              <div style="width:50px;height:50px;background:#d1fae5;border-radius:10px;display:flex;align-items:center;justify-content:center;font-size:1.5rem;flex-shrink:0">?</div>
              <div style="flex:1">
                <div style="font-weight:700;font-size:0.9rem">????????????????</div>
                <div class="course-progress">
                  <div class="progress-label"><span>????????????</span><span>60%</span></div>
                  <div class="progress-bar"><div class="progress-fill" style="width:60%"></div></div>
                </div>
              </div>
              <button class="btn btn-primary btn-sm" onclick="showClassroom(2)">????????</button>
            </div>
          </div>
        </div>
      </div>

      <!-- My Courses Tab -->
      <div id="dash-mycourses" style="display:none">
        <h2 style="font-family:'Chakra Petch',sans-serif;font-size:1.5rem;font-weight:700;margin-bottom:1.5rem">???????????</h2>
        <div class="grid-3">
          <div class="course-card">
            <div class="course-thumb blue"><span>?</span></div>
            <div class="course-body">
              <div class="course-title">??????????????????? C</div>
              <div class="course-progress">
                <div class="progress-label"><span>????????????</span><span>33%</span></div>
                <div class="progress-bar"><div class="progress-fill" style="width:33%"></div></div>
              </div>
              <button class="btn btn-primary" style="width:100%" onclick="showClassroom(1)">????????</button>
            </div>
          </div>
          <div class="course-card">
            <div class="course-thumb green"><span>?</span></div>
            <div class="course-body">
              <div class="course-title">????????????????</div>
              <div class="course-progress">
                <div class="progress-label"><span>????????????</span><span>60%</span></div>
                <div class="progress-bar"><div class="progress-fill" style="width:60%"></div></div>
              </div>
              <button class="btn btn-primary" style="width:100%" onclick="showClassroom(2)">????????</button>
            </div>
          </div>
          <div class="course-card">
            <div class="course-thumb purple"><span>??</span></div>
            <div class="course-body">
              <div class="course-title">??????????????????</div>
              <div class="course-progress">
                <div class="progress-label"><span>????????????</span><span>100%</span></div>
                <div class="progress-bar"><div class="progress-fill" style="width:100%;background:linear-gradient(90deg,var(--success),#34d399)"></div></div>
              </div>
              <button class="btn btn-success" style="width:100%">? ???????????</button>
            </div>
          </div>
        </div>
      </div>

      <!-- History Tab -->
      <div id="dash-history" style="display:none">
        <h2 style="font-family:'Chakra Petch',sans-serif;font-size:1.5rem;font-weight:700;margin-bottom:1.5rem">???????????????</h2>
        <div class="table-wrapper">
          <table>
            <thead>
              <tr><th>??????</th><th>?????</th><th>???????</th><th>?????????</th><th>?????</th></tr>
            </thead>
            <tbody>
              <tr><td>24 ?.?. 2026</td><td>??????????????????? C</td><td>????? 2: ???????????????????</td><td>45 ????</td><td><span class="badge badge-info">??????????</span></td></tr>
              <tr><td>23 ?.?. 2026</td><td>????????????????</td><td>????? 8: JavaScript ???????</td><td>60 ????</td><td><span class="badge badge-success">???????</span></td></tr>
              <tr><td>22 ?.?. 2026</td><td>??????????????????? C</td><td>????? 1: ????????????? C</td><td>40 ????</td><td><span class="badge badge-success">???????</span></td></tr>
              <tr><td>20 ?.?. 2026</td><td>??????????????????</td><td>????? 10: SQL ???????</td><td>55 ????</td><td><span class="badge badge-success">???????</span></td></tr>
              <tr><td>18 ?.?. 2026</td><td>????????????????</td><td>????? 7: CSS Advanced</td><td>50 ????</td><td><span class="badge badge-success">???????</span></td></tr>
            </tbody>
          </table>
        </div>
      </div>

      <!-- Results Tab -->
      <div id="dash-results" style="display:none">
        <h2 style="font-family:'Chakra Petch',sans-serif;font-size:1.5rem;font-weight:700;margin-bottom:1.5rem">???????????????</h2>
        <div class="table-wrapper">
          <table>
            <thead>
              <tr><th>??????</th><th>?????</th><th>??????</th><th>?????</th><th>??</th></tr>
            </thead>
            <tbody>
              <tr><td>24 ?.?. 2026</td><td>??????????????????? C</td><td><span class="badge badge-info">Pre-Test</span></td><td>8/10 (80%)</td><td><span class="badge badge-success">????</span></td></tr>
              <tr><td>22 ?.?. 2026</td><td>????????????????</td><td><span class="badge badge-warning">Post-Test</span></td><td>9/10 (90%)</td><td><span class="badge badge-success">????</span></td></tr>
              <tr><td>20 ?.?. 2026</td><td>??????????????????</td><td><span class="badge badge-warning">Post-Test</span></td><td>7/10 (70%)</td><td><span class="badge badge-success">????</span></td></tr>
              <tr><td>18 ?.?. 2026</td><td>??????????????????</td><td><span class="badge badge-info">Pre-Test</span></td><td>5/10 (50%)</td><td><span class="badge badge-danger">???????</span></td></tr>
              <tr><td>15 ?.?. 2026</td><td>????????????????</td><td><span class="badge badge-info">Pre-Test</span></td><td>6/10 (60%)</td><td><span class="badge badge-success">????</span></td></tr>
            </tbody>
          </table>
        </div>
      </div>

      <!-- Profile Tab -->
      <div id="dash-profile" style="display:none">
        <h2 style="font-family:'Chakra Petch',sans-serif;font-size:1.5rem;font-weight:700;margin-bottom:1.5rem">???????</h2>
        <div class="card" style="max-width:600px">
          <div style="text-align:center;margin-bottom:2rem">
            <div class="avatar" style="width:80px;height:80px;font-size:2rem;margin:0 auto 1rem" id="profileAvatar">?</div>
            <div style="font-weight:700;font-size:1.25rem" id="profileName">????????</div>
            <div style="color:var(--gray);font-size:0.875rem">???????? ? ???????? ?.?. 2026</div>
          </div>
          <div class="form-group"><div class="form-label">??????????</div><input class="form-control" id="profileUsername" value="student" readonly></div>
          <div class="form-group"><div class="form-label">????-???????</div><input class="form-control" id="profileFullname"></div>
          <div class="form-group"><div class="form-label">?????</div><input class="form-control" type="email" placeholder="email@example.com"></div>
          <div class="form-group"><div class="form-label">???????????????????</div><input class="form-control" type="password" placeholder="????????????"></div>
          <button class="btn btn-primary" onclick="notify('??????????','????????????????????????????????')">? ????????????????????</button>
        </div>
      </div>

    </div>
  </div>
</div>

<!-- ======================== PAGE: LOGIN ======================== -->
<div class="page" id="page-login">
  <div class="auth-page">
    <div class="auth-card">
      <div class="auth-logo">
        <div class="logo-icon">?</div>
        <h2>???????????</h2>
        <p>??????????????????? LearnHub</p>
      </div>
      <div class="form-group">
        <div class="form-label">??????????</div>
        <div class="input-icon">
          <span class="icon">?</span>
          <input class="form-control" id="loginUser" placeholder="??????????????" value="student">
        </div>
      </div>
      <div class="form-group">
        <div class="form-label">????????</div>
        <div class="input-icon">
          <span class="icon">?</span>
          <input class="form-control" type="password" id="loginPass" placeholder="????????????" value="1222">
        </div>
      </div>
      <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:1.25rem">
        <label style="display:flex;align-items:center;gap:6px;font-size:0.875rem;cursor:pointer">
          <input type="checkbox" checked> ???????
        </label>
        <a href="#" style="font-size:0.875rem;color:var(--primary);text-decoration:none">????????????</a>
      </div>
      <button class="btn btn-primary" style="width:100%;padding:0.75rem" onclick="doLogin()">???????????</button>
      <div class="divider">????</div>
      <button class="btn btn-outline" style="width:100%;padding:0.625rem" onclick="notify('Google Login','?????????????????????????????')">
        ? ??????????????? Google
      </button>
      <div class="auth-switch">?????????????? <a href="#" onclick="showPage('register')">??????????????</a></div>
    </div>
  </div>
</div>

<!-- ======================== PAGE: REGISTER ======================== -->
<div class="page" id="page-register">
  <div class="auth-page">
    <div class="auth-card" style="max-width:500px">
      <div class="auth-logo">
        <div class="logo-icon">?</div>
        <h2>???????????</h2>
        <p>?????????????????????? LearnHub ??????</p>
      </div>
      <div style="display:grid;grid-template-columns:1fr 1fr;gap:1rem">
        <div class="form-group">
          <div class="form-label">????</div>
          <input class="form-control" id="regFirstname" placeholder="????">
        </div>
        <div class="form-group">
          <div class="form-label">???????</div>
          <input class="form-control" placeholder="???????">
        </div>
      </div>
      <div class="form-group">
        <div class="form-label">??????????</div>
        <div class="input-icon">
          <span class="icon">?</span>
          <input class="form-control" id="regUser" placeholder="?????????? (??????????)">
        </div>
      </div>
      <div class="form-group">
        <div class="form-label">?????</div>
        <div class="input-icon">
          <span class="icon">?</span>
          <input class="form-control" type="email" placeholder="email@example.com">
        </div>
      </div>
      <div class="form-group">
        <div class="form-label">????????</div>
        <div class="input-icon">
          <span class="icon">?</span>
          <input class="form-control" type="password" id="regPass" placeholder="???????? (????????? 8 ????????)">
        </div>
      </div>
      <div class="form-group">
        <div class="form-label">??????????????</div>
        <div class="input-icon">
          <span class="icon">?</span>
          <input class="form-control" type="password" placeholder="??????????????????????">
        </div>
      </div>
      <div style="margin-bottom:1.25rem">
        <label style="display:flex;align-items:flex-start;gap:8px;font-size:0.8rem;color:var(--gray);cursor:pointer">
          <input type="checkbox" style="margin-top:2px"> ????????? <a href="#" style="color:var(--primary)">?????????????????</a> ??? <a href="#" style="color:var(--primary)">?????????????????????</a>
        </label>
      </div>
      <button class="btn btn-primary" style="width:100%;padding:0.75rem" onclick="doRegister()">??????????????</button>
      <div class="auth-switch">???????????????? <a href="#" onclick="showPage('login')">???????????</a></div>
    </div>
  </div>
</div>

<script>
  let currentPage = 'home';
  let currentUser = null;
  let quizMode = 'pre';
  let currentQuestion = 1;
  let totalQuestions = 5;
  let correctAnswers = 0;
  let answered = false;

  const questions = [
    { q: '??????????? C ???????????????????', choices: ['Bill Gates','Linus Torvalds','Dennis Ritchie','James Gosling'], correct: 2 },
    { q: '??????????????????????? C?', choices: ['print()','System.out.println()','printf()','echo'], correct: 2 },
    { q: '????????????????????????????????????? C?', choices: ['int','char','bool','float'], correct: 3 },
    { q: '????????????????????????????????? C?', choices: ['.','#',';',':'], correct: 2 },
    { q: '?????????????? C ???????????', choices: ['int x = 5;','integer x = 5;','var x = 5;','x = int 5;'], correct: 0 },
  ];

  function showPage(page) {
    document.querySelectorAll('.page').forEach(p => p.classList.remove('active'));
    document.getElementById('page-' + page).classList.add('active');
    document.querySelectorAll('.navbar-nav a').forEach(a => a.classList.remove('active'));
    const navEl = document.getElementById('nav-' + page);
    if (navEl) navEl.classList.add('active');
    currentPage = page;
    window.scrollTo(0, 0);
  }

  function showClassroom(courseId) {
    const titles = {1:'??????????????????? C', 2:'????????????????', 3:'??????????????????'};
    document.getElementById('classroomTitle').textContent = titles[courseId] || '??????????';
    showPage('classroom');
  }

  function showQuiz(mode) {
    quizMode = mode;
    currentQuestion = 1;
    correctAnswers = 0;
    answered = false;
    loadQuestion(0);
    document.getElementById('quizType').textContent = mode === 'pre' ? '? Pre-Test (?????????)' : '? Post-Test (?????????)';
    showPage('quiz');
  }

  function loadQuestion(idx) {
    const q = questions[idx];
    document.getElementById('questionText').textContent = (idx+1) + '. ' + q.q;
    document.getElementById('quizNum').textContent = (idx+1) + '/' + totalQuestions;
    document.getElementById('quizProgressFill').style.width = ((idx+1)/totalQuestions*100) + '%';
    const letters = ['A','B','C','D'];
    const container = document.getElementById('choicesContainer');
    container.innerHTML = '';
    q.choices.forEach((c, i) => {
      const div = document.createElement('div');
      div.className = 'choice';
      div.innerHTML = `<div class="choice-letter">${letters[i]}</div> ${c}`;
      div.onclick = () => selectChoice(div, i === q.correct);
      container.appendChild(div);
    });
    document.getElementById('nextBtn').disabled = true;
    answered = false;
  }

  function selectChoice(el, isCorrect) {
    if (answered) return;
    answered = true;
    const allChoices = document.querySelectorAll('.choice');
    allChoices.forEach(c => { c.style.pointerEvents = 'none'; });
    if (isCorrect) { el.classList.add('correct'); correctAnswers++; }
    else { el.classList.add('wrong'); }
    document.getElementById('nextBtn').disabled = false;
    document.getElementById('nextBtn').textContent = currentQuestion < totalQuestions ? '????? ?' : '????????? ?';
  }

  function nextQuestion() {
    if (currentQuestion < totalQuestions) {
      currentQuestion++;
      loadQuestion(currentQuestion - 1);
    } else {
      showResult();
    }
  }

  function showResult() {
    const score = Math.round(correctAnswers / totalQuestions * 100);
    document.getElementById('resultScore').textContent = score;
    document.getElementById('correctCount').textContent = correctAnswers;
    document.getElementById('wrongCount').textContent = totalQuestions - correctAnswers;
    if (score >= 80) {
      document.getElementById('resultEmoji').textContent = '?';
      document.getElementById('resultTitle').textContent = '?????????!';
      document.getElementById('resultSub').textContent = '????????????????????? ????? ' + score + '%';
    } else if (score >= 60) {
      document.getElementById('resultEmoji').textContent = '?';
      document.getElementById('resultTitle').textContent = '??!';
      document.getElementById('resultSub').textContent = '??????????????? ????? ' + score + '%';
    } else {
      document.getElementById('resultEmoji').textContent = '?';
      document.getElementById('resultTitle').textContent = '???????????????';
      document.getElementById('resultSub').textContent = '???????????????????????? ????? ' + score + '%';
    }
    showPage('result');
  }

  function goBack() { showPage('classroom'); }

  function switchTab(el, tabId) {
    const parent = el.parentElement;
    parent.querySelectorAll('.tab').forEach(t => t.classList.remove('active'));
    el.classList.add('active');
    const panel = el.closest('.card, .section, div').parentElement;
    document.querySelectorAll('.tab-content').forEach(t => t.classList.remove('active'));
    document.getElementById(tabId).classList.add('active');
  }

  function switchDashTab(tab) {
    ['overview','mycourses','history','results','profile'].forEach(t => {
      const el = document.getElementById('dash-' + t);
      if (el) el.style.display = t === tab ? 'block' : 'none';
    });
  }

  function setSideActive(el) {
    document.querySelectorAll('.sidebar-item').forEach(i => i.classList.remove('active'));
    el.classList.add('active');
  }

  function doLogin() {
    const user = document.getElementById('loginUser').value;
    const pass = document.getElementById('loginPass').value;
    if (!user || !pass) { notify('??????????','??????????????????????????????'); return; }
    currentUser = { username: user, name: user === 'student' ? '???????? ???????' : user };
    updateUserUI();
    notify('?????????????????','???????????? ' + currentUser.name);
    showPage('dashboard');
  }

  function doRegister() {
    const user = document.getElementById('regUser').value;
    const name = document.getElementById('regFirstname').value;
    if (!user || !name) { notify('??????????','?????????????????????'); return; }
    currentUser = { username: user, name: name };
    updateUserUI();
    notify('?????????????????','???????????? ' + name + ' ??? LearnHub!');
    showPage('dashboard');
  }

  function updateUserUI() {
    if (!currentUser) return;
    const initial = currentUser.name.charAt(0);
    document.getElementById('navActions').style.display = 'none';
    document.getElementById('navActionsLoggedIn').style.display = 'flex';
    document.getElementById('nav-dashboard').style.display = 'inline-block';
    document.getElementById('userNameDisplay').textContent = currentUser.name.split(' ')[0];
    document.getElementById('userAvatar').textContent = initial;
    document.getElementById('sidebarAvatar').textContent = initial;
    document.getElementById('sidebarName').textContent = currentUser.name;
    document.getElementById('greetName').textContent = currentUser.name.split(' ')[0];
    document.getElementById('profileAvatar').textContent = initial;
    document.getElementById('profileName').textContent = currentUser.name;
    document.getElementById('profileFullname').value = currentUser.name;
    document.getElementById('profileUsername').value = currentUser.username;
  }

  function logout() {
    currentUser = null;
    document.getElementById('navActions').style.display = 'flex';
    document.getElementById('navActionsLoggedIn').style.display = 'none';
    document.getElementById('nav-dashboard').style.display = 'none';
    notify('??????????????','?????????????????? LearnHub');
    showPage('home');
  }

  function notify(title, msg) {
    document.getElementById('notifTitle').textContent = '? ' + title;
    document.getElementById('notifMsg').textContent = msg;
    const n = document.getElementById('notification');
    n.classList.add('show');
    setTimeout(() => n.classList.remove('show'), 3000);
  }

  function playVideo() {
    notify('???????????????','????? 2: ???????????????????');
  }
</script>
</body>
</html>