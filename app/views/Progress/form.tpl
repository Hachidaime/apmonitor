<!-- prettier-ignore -->
{extends file='Templates/mainlayout.tpl'} 

{block 'style'}
<!-- Ekko Lightbox -->
<link rel="stylesheet" href="../plugins/ekko-lightbox/ekko-lightbox.css" />
<!-- prettier-ignore -->
{/block}

{block name='content'}
<div class="card rounded-0">
  <div class="card-header bg-gradient-navy rounded-0">
    <h3 class="card-title text-warning">{$subtitle}</h3>
  </div>
  <!-- /.card-header -->
  <!-- form start -->
  <form id="my_form" role="form" method="POST">
    <input type="hidden" id="id" name="id" value="{$detail.id}" />
    <div class="card-body">
      <div class="form-group row">
        <label
          for="prog_physical"
          class="col-lg-2 col-sm-3 col-form-label text-sm-right"
        >
          Fisik (%):
        </label>
        <div class="col-lg-2 col-sm-3 col-6">
          <input
            type="number"
            class="form-control rounded-0 {if $error.prog_physical}is-invalid{/if}"
            id="prog_physical"
            name="prog_physical"
            value="{$detail.prog_physical|default:'0.00'}"
            autocomplete="off"
            min="0"
            max="100"
            step=".10"
          />
          <div class="invalid-feedback">
            {$error.prog_physical}
          </div>
        </div>
      </div>

      <div class="form-group row">
        <label
          for="prog_physical_img"
          class="col-lg-2 col-sm-3 col-form-label text-sm-right"
        >
          Foto Fisik:
        </label>
        <div class="col-lg-10 col-sm-9">
          <div class="input-group">
            <div class="input-group-prepend">
              <span class="input-group-text rounded-0"
                ><i class="fas fa-file-image"></i
              ></span>
            </div>
            <div class="custom-file">
              <input
                type="file"
                class="custom-file-input file-upload"
                accept="image/*"
                data-id="prog_physical_img"
              />
              <label
                class="custom-file-label rounded-0"
                for="prog_physical_img"
              ></label>
            </div>
          </div>

          <input
            type="hidden"
            class="input-file"
            name="prog_physical_img"
            id="prog_physical_img"
            value="{$detail.prog_physical_img}"
            data-id="{$prog_physical_img}"
          />

          <div
            id="preview_prog_physical_img"
            class="mt-2"
            style="display: none;"
          >
            <a
              href="{$smarty.const.BASE_URL}/upload/img/progress/{$detail.id}/{$detail.prog_physical_img}"
              data-toggle="lightbox"
            >
              <img
                src="{$smarty.const.BASE_URL}/upload/img/progress/{$detail.id}/{$detail.prog_physical_img}"
                class="img-fluid"
                width="300"
              />
            </a>
          </div>

          <ul
            id="file_action_prog_physical_img"
            class="list-group mt-2"
            style="display: none;"
          >
            <li
              class="list-group-item d-flex justify-content-between align-items-center py-1 px2"
            >
              <span class="filename">{$detail.prog_physical_img}</span>
              <a
                class="badge badge-light badge-pill"
                title="Download"
                href="{$smarty.const.BASE_URL}/upload/img/progress/{$detail.id}/{$detail.prog_physical_img}"
                download
                ><i class="fas fa-download"></i
              ></a>
            </li>
          </ul>
        </div>
      </div>

      <div class="form-group row">
        <label
          for="prog_finance"
          class="col-lg-2 col-sm-3 col-form-label text-sm-right"
        >
          Keuangan (%):
        </label>
        <div class="col-lg-2 col-sm-3 col-6">
          <input
            type="number"
            class="form-control rounded-0 {if $error.prog_finance}is-invalid{/if}"
            id="prog_finance"
            name="prog_finance"
            value="{$detail.prog_finance|default:'0.00'}"
            autocomplete="off"
            min="0"
            max="100"
            step=".10"
          />
          <div class="invalid-feedback">
            {$error.prog_finance}
          </div>
        </div>
      </div>

      <div class="form-group row">
        <label
          for="prog_document"
          class="col-lg-2 col-sm-3 col-form-label text-sm-right"
        >
          Dokumen Pendukung:
        </label>
        <div class="col-lg-10 col-sm-9">
          <div class="input-group">
            <div class="input-group-prepend">
              <span class="input-group-text rounded-0"
                ><i class="fas fa-file-pdf"></i
              ></span>
            </div>
            <div class="custom-file">
              <input
                type="file"
                class="custom-file-input file-upload"
                accept="application/pdf"
                data-id="prog_document"
              />
              <label
                class="custom-file-label rounded-0"
                for="prog_document"
              ></label>
            </div>
          </div>
          <input
            type="hidden"
            class="input-file"
            name="prog_document"
            id="prog_document"
            value="{$detail.prog_document}"
            data-id="{$prog_document}"
          />

          <ul
            id="file_action_prog_document"
            class="list-group mt-2"
            style="display: none;"
          >
            <li
              class="list-group-item d-flex justify-content-between align-items-center py-1 px2"
            >
              <span class="filename">{$detail.prog_document}</span>
              <a
                class="badge badge-light badge-pill"
                title="Download"
                href="{$smarty.const.BASE_URL}/upload/img/progress/{$detail.id}/{$detail.prog_document}"
                download
                ><i class="fas fa-download"></i
              ></a>
            </li>
          </ul>
        </div>
      </div>
    </div>
    <!-- /.card-body -->

    <div class="card-footer">
      <!-- prettier-ignore -->
      {include 'Templates/buttons/submit.tpl'}
      {include 'Templates/buttons/form_back.tpl'}
    </div>
  </form>
</div>
<!-- prettier-ignore -->
{/block} 

{block 'script'} 
{literal}
<!-- bs-custom-file-input -->
<script src="{/literal}{$smarty.const.BASE_URL}{literal}/assets/plugins/bs-custom-file-input/bs-custom-file-input.min.js"></script>
<!-- Ekko Lightbox -->
<script src="{/literal}{$smarty.const.BASE_URL}{literal}/assets/plugins/ekko-lightbox/ekko-lightbox.min.js"></script>

<script>
  $(document).ready(function () {
    $('#btn_submit').click(() => {
      clearErrorMessage()
      save()
    })

    $('.file-upload').change(function () {
      upload(this)
    })

    $(document).on('click', '[data-toggle="lightbox"]', function (event) {
      event.preventDefault()
      $(this).ekkoLightbox({
        alwaysShowClose: false,
      })
    })

    bsCustomFileInput.init()
  })

  let save = () => {
    $.post(
      `${main_url}/submit`,
      $('#my_form').serialize(),
      (res) => {
        if (!res.success) {
          if (typeof res.msg === 'object') {
            $.each(res.msg, (id, message) => {
              showErrorMessage(id, message)
            })
          } else flash(res.msg, 'error')
        } else
          window.location = $('#id').val()
            ? `${main_url}/detail/${$('#id').val()}`
            : main_url
      },
      'JSON'
    )
  }
</script>
<!-- prettier-ignore -->
{/literal}
{/block}
