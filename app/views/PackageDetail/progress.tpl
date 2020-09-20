{block 'progressForm'}
<!-- Modal -->
<div
  class="modal fade"
  id="progressModal"
  data-backdrop="static"
  data-keyboard="false"
  tabindex="-1"
  aria-labelledby="progressModalLabel"
  aria-hidden="true"
>
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="progressModalLabel"></h5>
        <button
          type="button"
          class="close"
          data-dismiss="modal"
          aria-label="Close"
        >
          <span aria-hidden="true">&times;</span>
        </button>
      </div>

      <div class="modal-body">
        <div class="form-group">
          <label for="pkgd_no">
            Tanggal Terakhir Update
          </label>
          <input
            type="text"
            class="form-control-plaintext text-right"
            id="pkgdLastProgDate"
          />
        </div>
        <div class="form-group">
          <label for="pkgd_name">
            Total Progres Fisik
          </label>
          <input
            type="text"
            class="form-control-plaintext text-right"
            id="pkgdSumProgPhysical"
          />
        </div>
        <div class="form-group">
          <label for="pkgd_name">
            Total Progres Keuangan
          </label>
          <input
            type="text"
            class="form-control-plaintext text-right"
            id="pkgdSumProgFinance"
          />
        </div>
      </div>
      <div class="modal-footer">
        <button
          type="button"
          class="btn btn-light btn-flat"
          data-dismiss="modal"
        >
          Close
        </button>
      </div>
    </div>
  </div>
</div>
<!-- prettier-ignore -->
{/block}
