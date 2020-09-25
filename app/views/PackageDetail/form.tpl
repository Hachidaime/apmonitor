{block 'detailForm'}
<!-- Modal -->
<div
  class="modal fade"
  id="detailFormModal"
  data-backdrop="static"
  data-keyboard="false"
  tabindex="-1"
  aria-labelledby="detailFormModalLabel"
  aria-hidden="true"
>
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="detailFormModalLabel"></h5>
        <button
          type="button"
          class="close"
          data-dismiss="modal"
          aria-label="Close"
        >
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <form id="detail_form" role="form" method="POST">
        <input type="hidden" id="id" name="id" value="" />
        <div class="modal-body">
          <div class="form-group">
            <label for="pkgd_no">
              Nomor Paket
              <sup class="fas fa-asterisk text-red"></sup>
            </label>
            <input
              type="text"
              class="form-control rounded-0"
              id="pkgd_no"
              name="pkgd_no"
            />
            <div class="invalid-feedback"></div>
          </div>
          <div class="form-group">
            <label for="pkgd_name">
              Nama Paket
              <sup class="fas fa-asterisk text-red"></sup>
            </label>
            <input
              type="text"
              class="form-control rounded-0"
              id="pkgd_name"
              name="pkgd_name"
            />
            <div class="invalid-feedback"></div>
          </div>
          <div class="form-group">
            <p class="mb-1">
              <strong>Jenis Masa</strong>
              <sup class="fas fa-asterisk text-red"></sup>
            </p>
            <div
              class="btn-group btn-group-toggle"
              data-toggle="buttons"
              id="pkgd_period_type"
            >
              <label class="btn btn-outline-info btn-flat btn-sm btn-radio">
                <input
                  type="radio"
                  name="pkgd_period_type"
                  id="yearly"
                  autocomplete="off"
                  value="TAHUNAN"
                />
                TAHUNAN
              </label>
              <label class="btn btn-outline-info btn-flat btn-sm btn-radio">
                <input
                  type="radio"
                  name="pkgd_period_type"
                  id="multiyear"
                  autocomplete="off"
                  value="TAHUN JAMAK"
                />
                TAHUN JAMAK
              </label>
            </div>
            <div class="invalid-feedback"></div>
          </div>
          <div class="form-group">
            <p class="mb-1">
              <strong>Tahun Lanjutan</strong>
            </p>
            <input
              type="checkbox"
              id="pkgd_advanced_year"
              name="pkgd_advanced_year"
              data-bootstrap-switch
              data-off-color="danger"
              data-on-color="success"
              data-on-text="YES"
              data-off-text="NO"
              value="1"
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
          <button type="button" class="btn btn-success btn-flat" id="btn_save">
            Simpan
          </button>
        </div>
      </form>
    </div>
  </div>
</div>
<!-- prettier-ignore -->
{/block}

{block 'detailFormJS'}
<script src="{$smarty.const.BASE_URL}/assets/plugins/bootstrap-switch/js/bootstrap-switch.min.js"></script>
{literal}

<script>
  $(document).ready(function () {
    $('#detailFormModal').on('hidden.bs.modal', function (e) {
      $('#detail_form').trigger('reset')
      $('.btn-radio').removeClass('active')
      clearErrorMessage()
    })

    $('#pkgd_advanced_year').bootstrapSwitch(
      'state',
      $('#pkgd_advanced_year').prop('checked')
    )

    $('#detailFormModal #btn_save').click(() => {
      clearErrorMessage()
      saveDetail()
    })
  })

  let saveDetail = () => {
    $.post(
      `${BASE_URL}/packagedetail/submit`,
      $('#detail_form').serialize() + `&pkg_id=${$('#my_form #id').val()}`,
      (res) => {
        if (!res.success) {
          if (typeof res.msg === 'object') {
            $.each(res.msg, (id, message) => {
              showErrorMessage(id, message)
            })
          } else flash(res.msg, 'error')
        } else {
          flash(res.msg, 'success')
          $('#detailFormModal').modal('hide')
          pkgdSearch()
        }
      },
      'JSON'
    )
  }
</script>
<!-- prettier-ignore -->
{/literal}
{/block}
