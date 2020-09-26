<nav
  class="main-header navbar navbar-expand-md navbar-dark navbar-navy sticky-top"
>
  <div class="container">
    <button
      class="navbar-toggler order-1"
      type="button"
      data-toggle="collapse"
      data-target="#navbarCollapse"
      aria-controls="navbarCollapse"
      aria-expanded="false"
      aria-label="Toggle navigation"
    >
      <span class="fas fa-th my-1"></span>
    </button>

    <div class="collapse navbar-collapse order-3" id="navbarCollapse">
      <!-- Left navbar links -->
      <ul class="navbar-nav">
        {if $smarty.session.USER.usr_is_master eq 1}
        <li class="nav-item dropdown">
          <a
            id="dropdownSubMenu1"
            href="#"
            data-toggle="dropdown"
            aria-haspopup="true"
            aria-expanded="false"
            class="nav-link dropdown-toggle"
          >
            Master
          </a>
          <ul
            aria-labelledby="dropdownSubMenu1"
            class="dropdown-menu border-0 shadow"
          >
            <li>
              <a href="{$smarty.const.BASE_URL}/user" class="dropdown-item">
                User
              </a>
            </li>
            <li>
              <a href="{$smarty.const.BASE_URL}/program" class="dropdown-item">
                Program
              </a>
            </li>
            <li>
              <a href="{$smarty.const.BASE_URL}/activity" class="dropdown-item">
                Kegiatan
              </a>
            </li>
          </ul>
        </li>
        <!-- prettier-ignore -->
        {/if}

        {if $smarty.session.USER.usr_is_package eq 1}
        <li class="nav-item dropdown">
          <a
            id="dropdownSubMenu1"
            href="#"
            data-toggle="dropdown"
            aria-haspopup="true"
            aria-expanded="false"
            class="nav-link dropdown-toggle"
          >
            Paket Kegiatan
          </a>
          <ul
            aria-labelledby="dropdownSubMenu1"
            class="dropdown-menu border-0 shadow"
          >
            <li>
              <a href="{$smarty.const.BASE_URL}/package" class="dropdown-item">
                Pemaketan
              </a>
            </li>
            <li>
              <a href="{$smarty.const.BASE_URL}/progress" class="dropdown-item">
                Progres Paket
              </a>
            </li>
          </ul>
        </li>
        <!-- prettier-ignore -->
        {/if}

        {if $smarty.session.USER.usr_is_report eq 1}
        <li class="nav-item dropdown">
          <a
            id="dropdownSubMenu1"
            href="#"
            data-toggle="dropdown"
            aria-haspopup="true"
            aria-expanded="false"
            class="nav-link dropdown-toggle"
          >
            Laporan
          </a>
          <ul
            aria-labelledby="dropdownSubMenu1"
            class="dropdown-menu border-0 shadow"
          >
            <li>
              <a
                href="{$smarty.const.BASE_URL}/progressreport"
                class="dropdown-item"
              >
                Perkembangan Capaian Kinerja
              </a>
            </li>
            <li>
              <a
                href="{$smarty.const.BASE_URL}/performancereport"
                class="dropdown-item"
              >
                Kinerja Pelaksanaan Paket Kegiatan
              </a>
            </li>
          </ul>
        </li>
        {/if}
      </ul>
    </div>

    <!-- Right navbar links -->
    <ul class="order-1 order-md-3 navbar-nav navbar-no-expand ml-auto">
      <li class="nav-item">
        <span class="nav-link"
          >TA:
          <strong class="text-warning"> {$smarty.session.FISCAL_YEAR}</strong>
        </span>
      </li>

      <div class="user-panel p-0 m-0 d-flex">
        <div class="info m-0 p-0">
          <a
            href="{$smarty.const.BASE_URL}/profile"
            class="d-block nav-link"
            title="Profil"
          >
            <i class="fas fa-user-circle"></i>
          </a>
        </div>
      </div>

      <li class="nav-item">
        <a
          class="nav-link"
          href="{$smarty.const.BASE_URL}/logout"
          title="Logout"
        >
          <i class="fas fa-sign-out-alt"></i>
        </a>
      </li>
    </ul>
  </div>
</nav>
