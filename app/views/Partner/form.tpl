{block 'partnerForm'}
<!-- Modal -->
<div
  class="modal fade"
  id="partnerFormModal"
  data-backdrop="static"
  data-keyboard="false"
  tabindex="-1"
  aria-labelledby="partnerFormModalLabel"
  aria-hidden="true"
>
  <div class="modal-dialog modal-lg modal-dialog-scrollable">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="partnerFormModalLabel"></h5>
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
        <form id="partner_form" role="form" method="POST">
          <input type="hidden" id="id" name="id" value="" />
          <div class="form-group row">
            <label
              for="pkgd_partner_name"
              class="col-lg-4 col-sm-6 col-form-label"
            >
              Nama Rekanan
              <sup class="fas fa-asterisk text-red"></sup>
              <span class="float-sm-right d-sm-inline d-none">:</span>
            </label>
            <div class="col-lg-8 col-sm-6">
              <input
                type="text"
                class="form-control rounded-0"
                id="pkgd_partner_name"
                name="pkgd_partner_name"
                autocomplete="off"
              />
              <div class="invalid-feedback"></div>
            </div>
          </div>

          <div class="form-group row">
            <label
              for="pkgd_contract_no"
              class="col-lg-4 col-sm-6 col-form-label"
            >
              Nomor Kontrak
              <sup class="fas fa-asterisk text-red"></sup>
              <span class="float-sm-right d-sm-inline d-none">:</span>
            </label>
            <div class="col-lg-3 col-sm-4">
              <input
                type="text"
                class="form-control rounded-0"
                id="pkgd_contract_no"
                name="pkgd_contract_no"
                autocomplete="off"
              />
              <div class="invalid-feedback"></div>
            </div>
          </div>

          <div class="form-group row">
            <label
              for="pkgd_contract_date"
              class="col-lg-4 col-sm-6 col-form-label"
            >
              Tanggal Kontrak
              <sup class="fas fa-asterisk text-red"></sup>
              <span class="float-sm-right d-sm-inline d-none">:</span>
            </label>
            <div class="col-lg-3 col-sm-4">
              <input
                type="text"
                class="form-control rounded-0 date-picker"
                id="pkgd_contract_date"
                name="pkgd_contract_date"
                autocomplete="off"
                data-toggle="datetimepicker"
                data-target="#pkgd_contract_date"
              />
              <div class="invalid-feedback"></div>
            </div>
          </div>

          <div class="form-group row">
            <label
              for="pkgd_contract_days"
              class="col-lg-4 col-sm-6 col-form-label"
            >
              Masa Kontrak (hari)
              <sup class="fas fa-asterisk text-red"></sup>
              <span class="float-sm-right d-sm-inline d-none">:</span>
            </label>
            <div class="col-lg-2 col-sm-3 col-6">
              <input
                type="number"
                class="form-control rounded-0 text-right"
                id="pkgd_contract_days"
                name="pkgd_contract_days"
                autocomplete="off"
                min="0"
              />
              <div class="invalid-feedback"></div>
            </div>
          </div>

          <div class="form-group row">
            <label
              for="pkgd_contract_end_date"
              class="col-lg-4 col-sm-6 col-form-label"
            >
              Tanggal Selesai Kontrak
              <sup class="fas fa-asterisk text-red"></sup>
              <span class="float-sm-right d-sm-inline d-none">:</span>
            </label>
            <div class="col-lg-3 col-sm-4">
              <input
                type="text"
                class="form-control rounded-0 date-picker"
                id="pkgd_contract_end_date"
                name="pkgd_contract_end_date"
                autocomplete="off"
                data-toggle="datetimepicker"
                data-target="#pkgd_contract_end_date"
              />
              <div class="invalid-feedback"></div>
            </div>
          </div>

          <div class="form-group row">
            <label
              for="pkgd_contract_value"
              class="col-lg-4 col-sm-6 col-form-label"
            >
              Nilai Kontrak (Rp)
              <sup class="fas fa-asterisk text-red"></sup>
              <span class="float-sm-right d-sm-inline d-none">:</span>
            </label>
            <div class="col-lg-4 col-sm-6">
              <input
                type="text"
                class="form-control rounded-0 money-format text-right"
                id="pkgd_contract_value"
                name="pkgd_contract_value"
                autocomplete="off"
                placeholder="0,00"
              />
              <div class="invalid-feedback"></div>
            </div>
          </div>
          <hr />
          <div class="form-group row">
            <label
              for="pkgd_addendum_no"
              class="col-lg-4 col-sm-6 col-form-label"
            >
              Nomor Addendum
              <span class="float-sm-right d-sm-inline d-none">:</span>
            </label>
            <div class="col-lg-8 col-sm-6">
              <input
                type="text"
                class="form-control rounded-0"
                id="pkgd_addendum_no"
                name="pkgd_addendum_no"
                autocomplete="off"
              />
              <div class="invalid-feedback"></div>
            </div>
          </div>

          <div class="form-group row">
            <label
              for="pkgd_addendum_date"
              class="col-lg-4 col-sm-6 col-form-label"
            >
              Tanggal Addendum
              <span class="float-sm-right d-sm-inline d-none">:</span>
            </label>
            <div class="col-lg-3 col-sm-4">
              <input
                type="text"
                class="form-control rounded-0 date-picker"
                id="pkgd_addendum_date"
                name="pkgd_addendum_date"
                autocomplete="off"
                data-toggle="datetimepicker"
                data-target="#pkgd_addendum_date"
              />
              <div class="invalid-feedback"></div>
            </div>
          </div>

          <div class="form-group row">
            <label
              for="pkgd_addendum_days"
              class="col-lg-4 col-sm-6 col-form-label"
            >
              Masa Addendum
              <span class="float-sm-right d-sm-inline d-none">:</span>
            </label>
            <div class="col-lg-2 col-sm-3 col-6">
              <input
                type="number"
                class="form-control rounded-0 text-right"
                id="pkgd_addendum_days"
                name="pkgd_addendum_days"
                autocomplete="off"
                min="0"
              />
              <div class="invalid-feedback"></div>
            </div>
          </div>

          <div class="form-group row">
            <label
              for="pkgd_addendum_end_date"
              class="col-lg-4 col-sm-6 col-form-label"
            >
              Tanggal Selesai Addendum
              <span class="float-sm-right d-sm-inline d-none">:</span>
            </label>
            <div class="col-lg-3 col-sm-4">
              <input
                type="text"
                class="form-control rounded-0 date-picker"
                id="pkgd_addendum_end_date"
                name="pkgd_addendum_end_date"
                autocomplete="off"
                data-toggle="datetimepicker"
                data-target="#pkgd_addendum_end_date"
              />
              <div class="invalid-feedback"></div>
            </div>
          </div>

          <div class="form-group row">
            <label
              for="pkgd_addendum_value"
              class="col-lg-4 col-sm-6 col-form-label"
            >
              Nilai Addendum
              <span class="float-sm-right d-sm-inline d-none">:</span>
            </label>
            <div class="col-lg-4 col-sm-6">
              <input
                type="text"
                class="form-control rounded-0 money-format text-right"
                id="pkgd_addendum_value"
                name="pkgd_addendum_value"
                autocomplete="off"
                placeholder="0,00"
              />
              <div class="invalid-feedback"></div>
            </div>
          </div>
        </form>
      </div>
      <div class="modal-footer">
        <button
          type="button"
          class="btn bg-gradient-light btn-flat m-0"
          data-dismiss="modal"
          style="width: 125px;"
        >
          <i class="fas fa-window-close mr-2"></i>
          Batal
        </button>
        <button
          type="button"
          class="btn bg-gradient-success btn-flat m-0"
          style="width: 125px;"
          id="btn_save"
        >
          <i class="fas fa-save mr-2"></i>
          Simpan
        </button>
      </div>
    </div>
  </div>
</div>
<!-- prettier-ignore -->
{/block}

{block 'partnerScript'}
<!-- Input Mask -->
<script src="{$smarty.const.BASE_URL}/assets/plugins/inputmask/min/jquery.inputmask.bundle.min.js"></script>

{literal}
<script>
  $(document).ready(function () {
    $('.date-picker').datetimepicker({
      format: 'DD/MM/YYYY',
      locale: 'id',
    })

    $('.money-format').inputmask({
      alias: 'numeric',
      groupSeparator: '.',
      radixPoint: ',',
      placeholder: '0,00',
      numericInput: true,
      autoGroup: true,
      autoUnmask: true,
    })

    $('#partnerFormModal').on('hidden.bs.modal', function (e) {
      $('#partner_form').trigger('reset')
      clearErrorMessage()
    })

    $('#partnerFormModal #btn_save').click(function () {
      clearErrorMessage()
      savePartner(this.dataset.id)
    })
  })

  let savePartner = (id) => {
    $.post(
      `${base_url}/partner/submit`,
      $('#partner_form').serialize(),
      (res) => {
        if (!res.success) {
          if (typeof res.msg === 'object') {
            $.each(res.msg, (id, message) => {
              showErrorMessage(id, message)
            })
          } else flash(res.msg, 'error')
        } else {
          flash(res.msg, 'success')
          $('#partnerFormModal').modal('hide')
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
