<!-- prettier-ignore -->
{extends file='Templates/mainlayout.tpl'} 

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
        <label for="pkg_fiscal_year" class="col-lg-3 col-sm-4 col-form-label">
          Tahun Anggaran
          <sup class="fas fa-asterisk text-red"></sup>
          <span class="float-sm-right d-sm-inline d-none">:</span>
        </label>
        <div class="col-lg-2 col-sm-3 col-6">
          <input
            type="text"
            class="form-control rounded-0 {if $error.pkg_fiscal_year}is-invalid{/if}"
            id="pkg_fiscal_year"
            name="pkg_fiscal_year"
            value="{$detail.pkg_fiscal_year}"
            autocomplete="off"
          />
          <div class="invalid-feedback"></div>
          <small>Format: YYYY. Contoh: 2020.</small>
        </div>
      </div>

      <div class="form-group row">
        <label
          for="prg_code"
          class="col-lg-3 col-sm-4 col-form-label"
        >
          Program
          <sup class="fas fa-asterisk text-red"></sup>
          <span class="float-sm-right d-sm-inline d-none">:</span>
        </label>
        <div class="col-lg-2 col-sm-3 col-6">
          <select class="custom-select rounded-0" name="prg_code" id="prg_code">
            <option value="">-- Pilih --</option>
            {section inner $program}
            <option
              value="{$program[inner].prg_code}"
              data-value="{$program[inner].prg_name}"
              {if $detail.prg_code eq $program[inner].prg_code}selected{/if}
            >
              {$program[inner].prg_code}
            </option>
            {/section}
          </select>
          <div class="invalid-feedback"></div>
        </div>
      </div>

      <div class="form-group row">
        <label for="prg_name" class="col-lg-3 col-sm-4 col-form-label">
          Nama Program
          <span class="float-sm-right d-sm-inline d-none">:</span>
        </label>
        <div class="col-lg-9 col-sm-8">
          <input
            type="text"
            class="form-control-plaintext rounded-0"
            id="prg_name"
            readonly
          />
        </div>
      </div>
      
      <div class="form-group row">
        <label
          for="act_code"
          class="col-lg-3 col-sm-4 col-form-label"
        >
          Kegiatan
          <sup class="fas fa-asterisk text-red"></sup>
          <span class="float-sm-right d-sm-inline d-none">:</span>
        </label>
        <div class="col-lg-2 col-sm-3 col-6">
          <select class="custom-select rounded-0" name="act_code" id="act_code">
            <option value="">-- Pilih --</option>
            {section inner $activity}
            <option
              value="{$activity[inner].act_code}"
              data-value="{$activity[inner].act_name}"
              {if $detail.act_code eq $activity[inner].act_code}selected{/if}
            >
              {$activity[inner].act_code}
            </option>
            {/section}
          </select>
          <div class="invalid-feedback"></div>
        </div>
      </div>

      <div class="form-group row">
        <label for="act_name" class="col-lg-3 col-sm-4 col-form-label">
          Nama Kegiatan
          <span class="float-sm-right d-sm-inline d-none">:</span>
        </label>
        <div class="col-lg-9 col-sm-8">
          <input
            type="text"
            class="form-control-plaintext rounded-0"
            id="act_name"
            readonly
          />
        </div>
      </div>

      {include 'PackageDetail/index.tpl'}
    </div>
    <!-- /.card-body -->

    <div class="card-footer">
      <!-- prettier-ignore -->
      {include 'Templates/buttons/submit.tpl'}
      {include 'Templates/buttons/back.tpl'}
    </div>
  </form>
</div>
<!-- prettier-ignore -->
{/block} 

{block 'script'} 
{literal}
<script>
  $(document).ready(function () {
    $('#prg_code').change(function(){
      if($(this).val()){
        $('#prg_name')
          .val($(this).find(`option[value=${$(this).val()}]`).data('value'))
      }
    })
      .change()

    $('#act_code').change(function(){
      if($(this).val()){
        $('#act_name')
          .val($(this).find(`option[value=${$(this).val()}]`).data('value'))
      }
    })
      .change()

    $('#btn_submit').click(() => {
      clearErrorMessage()
      save()
    })
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
        } else window.location = main_url
      },
      'JSON'
    )
  }
</script>
<!-- prettier-ignore -->
{/literal}
{/block}
