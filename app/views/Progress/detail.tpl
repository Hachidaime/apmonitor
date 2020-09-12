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
  <div class="card-body">
    <div class="form-group row">
      <label
        for="prog_physical"
        class="col-lg-2 col-sm-3 col-form-label text-sm-right"
        >Fisik (%):</label
      >
      <div class="col-lg-2 col-sm-3 col-6">
        <input
          type="text"
          class="form-control-plaintext border px-2"
          value="{$detail.prog_physical}"
          readonly
        />
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
        {if $detail.prog_physical_img ne ''}
        <div id="preview_prog_physical_img" class="mt-2">
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

        <ul id="file_action_prog_physical_img" class="list-group mt-2">
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
        {/if}
      </div>
    </div>

    <div class="form-group row">
      <div class="col-md-10 col-sm-9 col-12 offset-lg-2 offset-sm-3">
        <a
          href="{$smarty.const.BASE_URL}/{$smarty.session.ACTIVE.name}/edit/{$detail.id}"
          class="btn bg-gradient-warning btn-flat mr-2"
          style="width: 100px;"
        >
          <i class="fas fa-edit mr-2"></i>Ubah
        </a>
        <button
          class="btn bg-gradient-danger btn-flat"
          id="btn_hapus"
          data-id="{$detail.id}"
          style="width: 100px;"
        >
          <i class="fas fa-trash-alt mr-2"></i>Hapus
        </button>
      </div>
    </div>
  </div>
  <!-- /.card-body -->

  <div class="card-footer">
    <a
      href="{$smarty.const.BASE_URL}/{$smarty.session.ACTIVE.name}"
      class="btn bg-gradient-light btn-flat float-right"
      style="width: 125px;"
    >
      <i class="fas fa-backspace mr-2"></i>Kembali
    </a>
  </div>
</div>
<!-- prettier-ignore -->
{/block}

{block 'script'} 
{literal}
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
</script>
{/literal} {/block}
