<template>
  <div id="news">
    <PageHead :svgData="svgData"></PageHead>

    <section class="news-wrap">
      <div class="news-wrap__container container">
        <div class="row">
          <MotionType text="ニュース一覧" tagName="h2" class="ews-wrap__heading kerning--wide col-04--sm col-08--md col-04--lg"></MotionType>
          <div class="col-04--sm col-08--md col-08--lg">
            <ul class="news-wrap__list list">
              <li class="list__item fadein">
                <FadeIn>
                  <a class="list__item-link list__item-link--multiple-line list__item-link--underline" href="/news/article">
                    <div class="list__item-text">
                      <span class="news-wrap__item-date text-caption">NOV 01, 2019</span>
                      <p>記事タイトル○○○○○○○○○○○○○○○○</p>
                    </div>
                  </a>
                </FadeIn>
              </li>
              <li class="list__item fadein">
                <FadeIn>
                  <a class="list__item-link list__item-link--multiple-line list__item-link--underline" href="/news/article">
                    <div class="list__item-text">
                      <span class="news-wrap__item-date text-caption">NOV 01, 2019</span>
                      <p>記事タイトル○○○○○○○○○○○○○○○○</p>
                    </div>
                  </a>
                </FadeIn>
              </li>
              <li class="list__item fadein">
                <FadeIn>
                  <a class="list__item-link list__item-link--multiple-line list__item-link--underline" href="/news/article">
                    <div class="list__item-text">
                      <span class="news-wrap__item-date text-caption">NOV 01, 2019</span>
                      <p>記事タイトル○○○○○○○○○○○○○○○○</p>
                    </div>
                  </a>
                </FadeIn>
              </li>
              <li class="list__item fadein">
                <FadeIn>
                  <a class="list__item-link list__item-link--multiple-line list__item-link--underline" href="/news/article">
                    <div class="list__item-text">
                      <span class="news-wrap__item-date text-caption">NOV 01, 2019</span>
                      <p>記事タイトル○○○○○○○○○○○○○○○○</p>
                    </div>
                  </a>
                </FadeIn>
              </li>
              <li class="list__item fadein">
                <FadeIn>
                  <a class="list__item-link list__item-link--multiple-line list__item-link--underline" href="/news/article">
                    <div class="list__item-text">
                      <span class="news-wrap__item-date text-caption">NOV 01, 2019</span>
                      <p>記事タイトル○○○○○○○○○○○○○○○○</p>
                    </div>
                  </a>
                </FadeIn>
              </li>
              <li class="list__item fadein">
                <FadeIn>
                  <a class="list__item-link list__item-link--multiple-line list__item-link--underline" href="/news/article">
                    <div class="list__item-text">
                      <span class="news-wrap__item-date text-caption">NOV 01, 2019</span>
                      <p>記事タイトル○○○○○○○○○○○○○○○○</p>
                    </div>
                  </a>
                </FadeIn>
              </li>
              <li class="list__item fadein">
                <FadeIn>
                  <a class="list__item-link list__item-link--multiple-line list__item-link--underline" href="/news/article">
                    <div class="list__item-text">
                      <span class="news-wrap__item-date text-caption">NOV 01, 2019</span>
                      <p>記事タイトル○○○○○○○○○○○○○○○○</p>
                    </div>
                  </a>
                </FadeIn>
              </li>
              <li class="list__item fadein">
                <FadeIn>
                  <a class="list__item-link list__item-link--multiple-line list__item-link--underline" href="/news/article">
                    <div class="list__item-text">
                      <span class="news-wrap__item-date text-caption">NOV 01, 2019</span>
                      <p>記事タイトル○○○○○○○○○○○○○○○○</p>
                    </div>
                  </a>
                </FadeIn>
              </li>
              <li class="list__item fadein">
                <FadeIn>
                  <a class="list__item-link list__item-link--multiple-line list__item-link--underline" href="/news/article">
                    <div class="list__item-text">
                      <span class="news-wrap__item-date text-caption">NOV 01, 2019</span>
                      <p>記事タイトル○○○○○○○○○○○○○○○○</p>
                    </div>
                  </a>
                </FadeIn>
              </li>
              <li class="list__item fadein">
                <FadeIn>
                  <a class="list__item-link list__item-link--multiple-line list__item-link--underline" href="/news/article">
                    <div class="list__item-text">
                      <span class="news-wrap__item-date text-caption">NOV 01, 2019</span>
                      <p>記事タイトル○○○○○○○○○○○○○○○○</p>
                    </div>
                  </a>
                </FadeIn>
              </li>
            </ul>
            <FadeIn>
              <div class="news-wrap__pagination fadein pagination">
                <a class="pagination__icon-btn pagination__icon-btn--disabled" href="#">
                  <i class="icon">chevron_left</i>
                </a>
                <ul class="pagination__list">
                  <li class="pagination__item pagination__item--current">
                    <a class="pagination__item-link" href="#">1</a>
                  </li>
                  <li class="pagination__item">
                    <a class="pagination__item-link" href="#">2</a>
                  </li>
                  <li class="pagination__item">
                    <a class="pagination__item-link" href="#">3</a>
                  </li>
                  <li class="pagination__item">
                    <a class="pagination__item-link" href="#">4</a>
                  </li>
                  <li class="pagination__item">
                    <a class="pagination__item-link" href="#">5</a>
                  </li>
                </ul>
                <a class="pagination__icon-btn" href="#">
                  <i class="icon">chevron_right</i>
                </a>
              </div>
            </FadeIn>
          </div>
        </div>
      </div>
    </section>

    <div class="end-logo">
      <img src="../assets/images/sprite/svg/logo.svg" alt="TWO Inc.">
    </div>

  </div>
</template>

<script>
import PageHead from "@/components/PageHead.vue";
import FadeIn from "@/components/FadeIn.vue";
import MotionType from "@/components/MotionType.vue";
import axios from "axios";

export default {
  name: "News",
  head: {
    title() {
      return {
        inner: 'NEWS',
        separator: '|',
        complement: '株式会社TWO',
      }
    },
    meta() {
      return [
        { name: 'description', content: '株式会社TWOの新着情報やプレスリリースなどをお知らせしております。' },
        { property: 'og:title', content: 'NEWS | 株式会社TWO' },
        { property: 'og:description', content: '株式会社TWOの新着情報やプレスリリースなどをお知らせしております。' },
        { property: 'og:url', content: 'https://two2.jp/news/' },
        { property: 'og:site_name', content: 'NEWS | 株式会社TWO' },
        { property: 'twitter:title', content: 'NEWS | 株式会社TWO' },
        { property: 'twitter:description', content: '株式会社TWOの新着情報やプレスリリースなどをお知らせしております。' },
      ]
    },
  },
  data() {
    return {
      svgData: [
        {svgName:'NEWS',svgSize:'0 0 640 116',parallaxData:['0.4','-0.4','0.8','-0.8','0.4','-0.4','0.8','-0.8',],svgItems:[
          'M30.43,101.52a5.65,5.65,0,0,1-1.25-2.85,51,51,0,0,1-.28-6.6V18.17L63.25,66.94V41.05L36.59,3.35H0v8.73H6.4q7.77,0,10,2.56a5.11,5.11,0,0,1,1.24,2.77,48.64,48.64,0,0,1,.29,6.6V92.07q0,7.92-2,9.93T6.4,104H0v8.65H48.6V104H40.43Q32.67,104,30.43,101.52Z',
          'M78.55,2.79v8.73h8.64q7.77,0,10,2.56a5.26,5.26,0,0,1,1.24,2.77,49.19,49.19,0,0,1,.28,6.6V90.63L63.25,40.49V66.38l32.59,46.27h13.85V23.45c0-5.28.66-8.59,2-9.93s4.5-2,9.57-2h5.29V2.79Z',
          'M233.09,104H215.44V59.56h11.13a36.82,36.82,0,0,1,6.52.54V50.68c-1.76.15-3.87.23-6.36.23H215.44V12.08h17.65V3.35H181.33V12h6.73q7.68,0,10,2.56c1,1.12,1.52,4.27,1.52,9.45V92.07q0,7.92-1.92,9.93t-9.6,2h-6.73v8.65h51.76Z',
          'M276.45,68.13h8.41v44.52H233.09V104h14.06q11,0,16.93-2.48a15.68,15.68,0,0,0,8.53-8Q275.56,87.18,276.45,68.13Zm-34.91-3a16.78,16.78,0,0,1,1.68,5.52q.48,3.28,1,12.89h8.33V29.94h-8.33q0,10.56-2,15.37a7.59,7.59,0,0,1-4.4,4.52,19.41,19.41,0,0,1-4.69.85V60.1C237.37,60.89,240.21,62.53,241.54,65.09ZM233.09,3.35v8.73h12q11.94,0,18.14,2.16a16,16,0,0,1,9.09,7.29q3.68,6.57,4.16,22.9h8.41V3.35Z',
          'M420.07,3.35H397.34v8.73h5.44c3.52,0,6.07.5,7.65,1.48s2.71,2.85,3.4,5.57l1.52,5.52L392.77,92.31l-19.45-69.9a20.63,20.63,0,0,1-.73-5.44,4,4,0,0,1,1.93-3.81q1.92-1.08,6.64-1.08h6.49V3.35H341.53v8.73h4.88c3.15,0,5.45.7,6.89,2.08a12,12,0,0,1,2.76,4.25q1.08,2.64,3.24,10.17l24,84.07H396l24.1-71.58Z',
          'M456.67,3.35v8.73h7.68q4.56,0,6.29,1c1.14.7,1.72,2,1.72,3.85a35.14,35.14,0,0,1-1.68,9.36L451.06,92.39,429.6,21.69a16.45,16.45,0,0,1-.8-5.05c0-1.86.58-3.09,1.72-3.68s3.51-.88,7.09-.88H445V3.35H420.07V41.07l22.26,71.58h12.82l26.18-87q2.48-8.4,4.84-11c1.58-1.7,4-2.56,7.41-2.56h4.32V3.35Z',
          'M549.92,31.38q0-15,10.89-23.22Q571.63.07,588,.07c2.42,0,4.66.15,6.8.36V10.1a47,47,0,0,0-6-.42q-12.57,0-19.38,5.93a15.18,15.18,0,0,0-5.52,11.93q0,9,8.08,13.61Q576.83,44,586,45.79l8.73,1.73V64.17l-8.25-1.81q-12.4-2.79-17.21-4.48A35.89,35.89,0,0,1,560.09,53Q549.92,45.64,549.92,31.38Zm44.84,74.11a37.62,37.62,0,0,1-24.82-12.06A36.79,36.79,0,0,1,562.81,83a75,75,0,0,1-4.32-15.69h-9v45.32h8.33l5.28-12.09q9.14,7.84,15.14,11a42.69,42.69,0,0,0,16.49,4.22Z',
          'M640,81.74q0,14.66-10.25,23.7-12,10.49-30,10.49c-1.72,0-3.37-.08-5-.19V105.49c1.39.13,2.8.19,4.24.19q11,0,18.1-5a17.89,17.89,0,0,0,8.09-15.54,15.79,15.79,0,0,0-6.81-13.45q-4.49-3.28-18.33-6.4l-5.29-1.16V47.52l7,1.39q20.25,4,28.82,10.89Q640,67.33,640,81.74ZM594.76,10.1a40.32,40.32,0,0,1,11.53,3.18,29.94,29.94,0,0,1,14.33,13.53q2.73,5.3,4.81,16.9h8.73V2.31h-7.53l-4.73,10Q611.58,5,604.77,2.51a43,43,0,0,0-10-2.08Z'
        ]}
      ],
    }
  },
  components: {
    PageHead,
    FadeIn,
    MotionType,
  },
  created : function() {
    axios.get('https://backend-two2-development.appspot.com/news').then(res => {
      console.log(res);
    })
    axios.get('http://localhost:8082/news').then(res => {
      console.log(res);
    })
  }
}
</script>

<style scoped lang="scss">
// News

.news-wrap {
  position: relative;
  width: 100%;
  @include media-query {
    margin-bottom: $space-09;
    padding-top: $space-09;
  }

  &__list {
    @include media-query($breakpoint: lg, $rule: max) {
      margin-top: $space-06;
    }
  }

  &__item-date {
    display: block;
    margin-bottom: $space-03;
  }

  &__pagination {
    margin-top: $space-06;
  }

  .pagination__item--current .pagination__item-link {
    font-weight: map-get($font-weight, bold);
  }
}

</style>
